package body UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK with SPARK_Mode,
  
is
   procedure processReceivedLmcpMessage(This : receivedLmcpMessage : in out Message) is
   begin
      case receivedLmcpMessage is
         when RoutePlanResponseKind =>
            declare
               rplan : RoutePlanResponse := receivedLmcpMessage.RoutePlanResponseContent;
               use Id_Plan_Pair_Maps;
               use Id_Plan_Pair_Maps.Formal_Model;
               use Id_Plan_Pair_Maps.Formal_Model.P;
               use RoutePlan_Lists;
               use RoutePlan_Lists.Formal_Model;
               use RoutePlan_Lists.Formal_Model.P;
               use RoutePlanResponse_Maps;
               use RoutePlanResponse_Maps.Formal_Model;
               use RoutePlanResponse_Maps.Formal_Model.P;

               Length_m_routePlans_Old  : constant Count_Type := Length (m_routePlans)
                 with Ghost;

            begin
               --  Assumption: there is enough room in the package state to handle the response.
               --  Could be put as a precondition to propagate it to the caller if we want to prove it.
               pragma Assume (m_routePlanResponses.Capacity > Length (m_routePlanResponses), "m_routePlanResponses is big enough");
               pragma Assume (m_routePlans.Capacity - Length (rplan.RouteResponses) >= Length (m_routePlans), "m_routePlans is big enough");

               --  Assumption: Response has fresh identifiers.
               --  Could be put as a precondition to propagate it to the caller if we want to prove it.
               pragma Assume (not Contains (m_routePlanResponses, rplan.ResponseID), "response id is fresh");
               pragma Assume ((for all p of rplan.RouteResponses => not Contains (m_routePlans, p.RouteID)), "route ids are fresh");
               pragma Assume ((for all c in rplan.RouteResponses =>
                                 (for all d in rplan.RouteResponses =>
                                    (if C /= D then
                                          Element (rplan.RouteResponses, C).RouteID /= Element (rplan.RouteResponses, D).RouteID))), "route ids are distinct");

               RoutePlanResponse_Maps.Insert (m_routePlanResponses, rplan.ResponseID, rplan);
               for C in rplan.RouteResponses loop
                  pragma Loop_Invariant (Length (m_routePlans) = Length_m_routePlans_Old + (Get (Positions (rplan.RouteResponses), C) - 1));
                  pragma Loop_Invariant (for all D in rplan.RouteResponses =>
                                           (if Get (RoutePlan_Lists.Formal_Model.Positions (rplan.RouteResponses), C) <=
                                              Get (RoutePlan_Lists.Formal_Model.Positions (rplan.RouteResponses), D)
                                            then not Contains (m_routePlans, Element (rplan.RouteResponses, D).RouteID)));
                  declare
                     p : RoutePlan renames Element (rplan.RouteResponses, C);
                  begin
                     Insert (m_routePlans, p.RouteID, (rplan.ResponseID, p));
                  end;
               end loop;
            end;
            CheckAllRoutePlans;
         when RouteRequestKind =>
            HandleRouteRequest (receivedLmcpMessage.RouteRequestContent);
         when others =>
            raise Program_Error;
      end case;
   end processReceivedLmcpMessage;

   procedure HandleRouteRequest (Request : in out RouteRequest) is
      RouteRequests : Int_64_Set;
      use Int_64_Sets;UxAS.Comms.LMCP_Net_Client.Service.
      use Int_64_Sets.Formal_Model;
      use Int_64_Sets.Formal_Model.P;
      use Int_64_Lists;
      use Int_64_Lists.Formal_Model;
      use Int_64_Lists.Formal_Model.P;
      use Int_64_Set_Maps;
      use Int_64_Set_Maps.Formal_Model;
      use Int_64_Set_Maps.Formal_Model.P;
      use Entity_State_Maps;
      use Entity_State_Maps.Formal_Model;
      use Entity_State_Maps.Formal_Model.P;

      Length_RouteRequests_Old : constant Count_Type := Length (RouteRequests)
        with Ghost;
      m_routeRequestId_Old     : constant Integer_64 := m_routeRequestId
        with Ghost;

   begin
      --  Assumption: there is enough room in the package state to handle the request.
      --  Could be put as a precondition to propagate it to the caller if we want to prove it.
      declare
         Lgth : Count_Type :=
           (if Is_Empty (Request.VehicleID) then Length (m_entityStates)
            else Length (Request.VehicleID))
             with Ghost;
      begin
         pragma Assume (Integer_64'Last - Integer_64 (Lgth) >= m_routeRequestId, "Integer_64 is big enough");
      end;
      pragma Assume (m_pendingRoute.Capacity > Length (m_pendingRoute), "m_pendingRoute is big enough");

      --  Assumption: Request has a fresh identifier.
      --  Could be put as a precondition to propagate it to the caller if we want to prove it.
      pragma Assume (not Contains (m_pendingRoute, Request.RequestID), "request id is fresh");

      if Is_Empty (Request.VehicleID) then
         for C in m_entityStates loop
            pragma Loop_Invariant (Length (Request.VehicleID) = Get (Positions (m_entityStates), C) - 1);
            Append (Request.VehicleID, Element (m_entityStates, C).ID);
         end loop;
      end if;

      for C in request.VehicleID loop
         pragma Loop_Invariant (for all I of RouteRequests => I < m_routeRequestId);
         pragma Loop_Invariant (Length (RouteRequests) = Length_RouteRequests_Old + (Get (Positions (request.VehicleID), C) - 1));
         pragma Loop_Invariant (m_routeRequestId = m_routeRequestId_Old + Integer_64 (Get (Positions (request.VehicleID), C) - 1));
         declare
            vehicleId   : Integer_64 renames Element (Request.VehicleID, C);
            -- create a new route plan request
            pRequest    : Message (RoutePlanRequestKind);
            planRequest : RoutePlanRequest renames pRequest.RoutePlanRequestContent;
         begin
            planRequest.AssociatedTaskID  := request.AssociatedTaskID;
            planRequest.IsCostOnlyRequest := request.IsCostOnlyRequest;
            planRequest.OperatingRegion   := request.OperatingRegion;
            planRequest.VehicleID         := vehicleId;
            planRequest.RequestID         := m_routeRequestId;
            planRequest.RouteRequests     := Request.RouteRequests;

            Insert (RouteRequests, m_routeRequestId);
            m_routeRequestId := m_routeRequestId + 1;

            if Contains (m_groundVehicles, vehicleId) then
               -- short-circuit and just plan with straight line planner
               if m_fastPlan then
                  EuclideanPlan (planRequest);
               else
                  -- send externally
                  sendSharedLmcpObjectLimitedCastMessage(GroundPathPlanner_GroupName, pRequest);
               end if;
            else
               -- send to aircraft planner
               sendSharedLmcpObjectLimitedCastMessage(AircraftPathPlanner_GroupName, pRequest);
            end if;
         end;
      end loop;
      Insert (m_pendingRoute,
              Key       => Request.RequestID,
              New_Item  => RouteRequests);

      -- if fast planning, then all routes should be complete; kick off response
      if m_fastPlan then
         CheckAllRoutePlans;
      end if;
   end HandleRouteRequest;

   procedure CheckAllRoutePlans is
      -- check pending route requests
      i : Int_64_Set_Maps.Cursor := Int_64_Set_Maps.First (m_pendingRoute);
   begin
      while Int_64_Set_Maps.Has_Element (m_pendingRoute, i) loop
         declare
            isFulfilled : Boolean := true;
         begin
            for j of Int_64_Set_Maps.Element (m_pendingRoute, i) loop
               if Int_64_Sets.Contains (Int_64_Set_Maps.Element (m_pendingRoute, i), j) then
                  isFulfilled := false;
                  exit;
               end if;
            end loop;

            if isFulfilled then
               SendRouteResponse (Int_64_Set_Maps.Key (m_pendingRoute, i));
               declare
                  to_del : Int_64_Set_Maps.Cursor := i;
               begin
                  Int_64_Set_Maps.Next (m_pendingRoute, i);
                  Int_64_Set_Maps.Delete (m_pendingRoute, to_del);
               end;
            else
               Int_64_Set_Maps.Next (m_pendingRoute, i);
            end if;
         end;
      end loop;

      -- check pending automation requests
      -- do not handle automation requests yet
   end CheckAllRoutePlans;

   procedure SendRouteResponse (routeKey : Integer_64) is
      pResponse : Message (RouteResponseKind);
      response  : RouteResponse renames pResponse.RouteResponseContent;
      route     : Int_64_Set renames Int_64_Set_Maps.Element (m_pendingRoute, routeKey);
   begin
      response.ResponseID := routeKey;
      for C in route loop
         pragma Loop_Invariant (RoutePlanResponse_Lists.Length (response.Routes) < Int_64_Sets.Formal_Model.P.Get (Int_64_Sets.Formal_Model.Positions (route), C));
         declare
            rId  : Integer_64 := Int_64_Sets.Element (route, C);
            plan : RoutePlanResponse_Maps.Cursor := RoutePlanResponse_Maps.Find (m_routePlanResponses, rId);
         begin
            if RoutePlanResponse_Maps.Has_Element (m_routePlanResponses, plan) then
               RoutePlanResponse_Lists.Append (response.Routes, RoutePlanResponse_Maps.Element (m_routePlanResponses, plan));

               -- delete all individual routes from storage
               RoutePlanResponse_Maps.Delete (m_routePlanResponses, plan);
            end if;
         end;
      end loop;

      -- send the results of the query
      sendSharedLmcpObjectBroadcastMessage(pResponse);
   end SendRouteResponse;

end UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK;
