with UxAS.Messages.Route.RoutePlan;

with Uxas.Messages.Route.RouteResponse; use Uxas.Messages.Route.RouteResponse;



with UxAS.Messages.Lmcptask.AssignmentCostMatrix; use UxAS.Messages.Lmcptask.AssignmentCostMatrix;
with UxAS.Messages.Lmcptask.UniqueAutomationRequest.SPARK_Boundary; use UxAS.Messages.Lmcptask.UniqueAutomationRequest.SPARK_Boundary;
with UxAS.Messages.Lmcptask.TaskOptionCost; use UxAS.Messages.Lmcptask.TaskOptionCost; 


with Afrl.Cmasi.ServiceStatus; use Afrl.Cmasi.ServiceStatus;
with Afrl.Cmasi.KeyValuePair;  use Afrl.Cmasi.KeyValuePair;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;


package body UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK with SPARK_Mode is
   
   
 
            
   procedure Send_Matrix( This : in out Route_Aggregator_Service;
                          AutoKey : Int64)
       
              
               
   is
      
      Matrix    :  AssignmentCostMatrix_Acc := new AssignmentCostMatrix;
      Areq   : My_UniqueAutomationRequest := 
        Wrap( Int64_Unique_Automation_Request_Maps.Element ( This.Unique_Automation_Request,
              AutoKey).Content);
      Route_Not_Found : Unbounded_String;
               
      Service_Status : ServiceStatus;
      Key_Pair : KeyValuePair;
               
      
               
   begin
      for R_Id of Int64_Pending_Auto_Req_Matrix.Element(Container => This.Pending_Auto_Req,
                                                        Key       => AutoKey) loop 
         if Int64_Pair_Int64_Route_Plan_Maps.Contains(This.Route_Plan,
                                                      R_ID)
         then
            declare
               Plan : Pair_Int64_Route_Plan := Int64_Pair_Int64_Route_Plan_Maps.Element(This.Route_Plan,
                                                                                        R_ID);
            begin
               if Int64_Aggregator_Task_Option_Pair_Maps.Contains(Container => This.Route_Task_Pairing,
                                                                  Key       => R_ID)
               then
                  declare
                     Task_Pair :AggregatorTaskOptionPair := Int64_Aggregator_Task_Option_Pair_Maps.Element( This.Route_Task_Pairing,
                                                                                                            R_Id);
                     Task_Option_Cost : TaskOptionCost_Acc := new TaskOptionCost;
                  begin
                     if (Plan.Returned_Route_Plan.GetRouteCost < 0)
                     then
                        Route_Not_Found := "V[" & Task_Pair.VehicleId & "](" & Task_Pair.PrevTaskId &  ","
                          & Task_Pair.PrevTaskOption & ")-(" & Task_Pair.TaskId & "," & Task_Pair.TaskOption & ")";
                     end if;
                              
                              
                     Task_Option_Cost.SetDestinationTaskID(Task_Pair.TaskId);
                     Task_Option_Cost.SetDestinationTaskOption(Task_Pair.TaskOption);
                     Task_Option_Cost.SetIntialTaskID(Task_Pair.PrevTaskId);
                     Task_Option_Cost.SetIntialTaskOption(Task_Pair.PrevTaskOption);
                     Task_Option_Cost.SetTimeToGo(Plan.Returned_Route_Plan.GetRouteCost);
                     Task_Option_Cost.SetVehicleID(Task_Pair.VehicleId);
                     Matrix.GetCostMatrix.Append(New_Item => Task_Option_Cost);
                     Int64_Aggregator_Task_Option_Pair_Maps.Delete(This.Route_Task_Pairing,
                                                                   Task_Pair);
                  end;
               end if;
                        
               Int64_Route_Plan_Responses_Maps.Delete(This.Route_Plan_Responses,
                                                       Plan.Reponse_ID);
               Int64_Pair_Int64_Route_Plan_Maps.Delete(This.Route_Plan,
                                                        R_ID);
            end;
         end if;
      end loop;
               
      This.Send_Shared_LMCP_Object_Broadcast_Message(Object_Any(Matrix));
      
      Int64_Task_Plan_Options_Maps.Clear(This.Task_Plan_Options);
               
               
      if Route_Not_Found'Length = 0 then
                  
         Service_Status.SetStatusType(Afrl.Cmasi.Enumerations.Information);
         Key_Pair.SetKey("RoutesNotFound - [VehicleId](StartTaskId,StartOptionId)-(EndTaskId,EndOptionId)");
                  
         Key_Pair.SetValue(Route_Not_Found);
         Append(Service_Status.GetInfo,
                Key_Pair);
         Key_Pair := null;
         THis.Send_LMCP_Object_Broadcast_Message(Service_Status);
         Put("RoutesNotFound - [VehicleId](StartTaskId,StartOptionId)-(EndTaskId,EndOptionId) :: " & Route_Not_Found);
               
      else
         Service_Status.SetStatusType(Afrl.Cmasi.Enumerations.Information);
         Key_Pair.SetKey("AssignmentMatrix - full");
         Append(Service_Status.GetInfo,
                Key_Pair);
         Key_Pair := null;
                  
                  
         This.Send_LMCP_Object_Broadcast_Message(Service_Status);
      end if;
   end Send_Matrix;
   
   --     -- void SendRouteResponse(int64_t);
   --     procedure Send_Route_Reponse ( This : in out Route_Aggregator_Service;
   --                                    RouteKey : Int64)
   --     is 
   --        Response  : constant RouteResponse_Acc := new RouteResponse;
   --        RouteList : constant Vect_RoutePlanResponse_Acc_Acc := Response.GetRoutes;
   --        Exepcted_Plan_Response_IDs : constant Int64_Set := Int64_Pending_Route_Matrix.Element(This.Pending_Route,
   --                                                                                              RouteKey);
   --        
   --     begin
   --          
   --        --  response->setResponseID(routeKey);
   --        Response.SetResponseID(RouteKey);
   --        
   --        --  for (auto& rId : m_pendingRoute[routeKey])
   --        for Plan_Reponse_Id of Exepcted_Plan_Response_IDs loop
   --           
   --           --  auto plan = m_routePlanResponses.find(rId);
   --           --  if (plan != m_routePlanResponses.end())
   --           if Int64_Route_Plan_Responses_Maps.Contains(This.Route_Plan_Responses,
   --                                                       Plan_Reponse_Id) then
   --              declare
   --                 Plan_Acc : RoutePlanResponse_Acc;
   --                    
   --              begin
   --                 Plan_Acc := RoutePlanResponse_Acc( Int64_Route_Plan_Responses_Maps.Element(This.Route_Plan_Responses,
   --                                                    Plan_Reponse_Id).Content);
   --                    
   --                 RouteList.Append(Plan_Acc);   -- clone here
   --                 
   --                 
   --                 
   --                 --  // delete all individual routes from storage
   --                 --  for (auto& i : plan->second->getRouteResponses())
   --                 for Route_Reponse of  Plan_Acc.GetRouteResponses.all loop
   --                      
   --                    M_RoutePlans.Erase(I->GetRouteID());
   --                    Int64_Pair_Int64_Route_Plan_Maps.Delete(This.Route_Plan,
   --                                                             Route_Reponse.GetRouteID);
   --                 end loop;
   --                 
   --                 
   --                 
   --                 --   m_routePlanResponses.erase(plan);   
   --                 Int64_Route_Plan_Responses_Maps.Delete(This.Route_Plan_Responses,
   --                                                         Plan_Reponse_Id);
   --              end;
   --           end if;
   --        end loop;
   --           
   --        --  sendSharedLmcpObjectBroadcastMessage(pResponse);
   --        This.Send_LMCP_Object_Broadcast_Message(Object_Any(Response));
   --           
   --       
   --           
   --     end Send_Route_Reponse;
   --     
   
   
   
   --     
   --     procedure Check_All_Route_Plans(This : in out Route_Aggregator_Service)
   --     is
   --        C : Int64_Pending_Route_Matrix :=
   --          Int64_Pending_Route_Matrix.First(Container => This.Pending_Route);
   --  
   --        I : Int64_Pending_Auto_Req_Matrix :=
   --          Int64_Pending_Auto_Req_Matrix.First(Container => THis.Pending_Auto_Req);
   --        
   --        
   --        
   --           
   --                
   --        
   --        
   --        
   --       
   --        
   --           
   --       
   --           
   --           
   --              
   --           
   --     begin
   --              
   --              
   --              
   --              
   --              
   --              
   --              
   --                      
   --                     
   --        
   --                 
   --  
   --        --  // check pending route requests
   --        -- auto i = m_pendingRoute.begin();
   --        -- while (i != m_pendingRoute.end())
   --  
   --        while Int64_Pending_Route_Matrix.Has_Element(Container => This.Pending_Route ,
   --                                                     Position  => C);
   --        loop
   --           declare
   --              -- bool isFulfilled = true;
   --              Is_Fulfilled : Boolean := True;
   --  
   --              -- i->first()
   --              Route_Id : Int64 :=
   --                Int64_Pending_Route_Matrix.Key(Container => This.Pending_Route,
   --                                               Position  => C);
   --  
   --              -- i->second()
   --              Liste_Route : Int64_Set :=
   --                Int64_Pending_Route_Matrix.Element(Container => THis.Pending_Route,
   --                                                   Position  => C);
   --           begin
   --  
   --              for Id_Request in Liste_Route loop
   --  
   --                 if (Int64_Route_Plan_Responses_Maps.Contains(Container => This.Route_Plan_Responses,
   --                                                              Key       => Id_Request))
   --                 then
   --  
   --                    Is_Fulfilled := False;
   --                    Break;
   --                 end if;
   --              end loop;
   --  
   --  
   --              Int64_Pending_Route_Matrix.Next(Container => THis.Pending_Route,
   --                                              Position  => C);
   --              if (Is_Fulfilled) then
   --  
   --                 This.Send_Route_Reponse(RouteKey => Route_Id);
   --                 Int64_Pending_Route_Matrix.Delete(Container => This.Pending_Route,
   --                                                   Key       => Route_Id);
   --              end if;
   --           end;
   --        end loop;
   --  
   --  
   --        -- // check pending automation requests
   --        -- auto k = m_pendingAutoReq.begin();
   --        -- while (k != m_pendingAutoReq.end())
   --        while Int64_Pending_Auto_Req_Matrix.Has_Element(Container => THis.Pending_Auto_Req,
   --                                                        Position  => I)
   --        loop
   --           declare
   --              Is_Fulfilled :Boolean := True;
   --  
   --              -- k->first()
   --              Req_Id : Int64_Pending_Auto_Req_Matrix.Key(Container => THis.Pending_Auto_Req,
   --                                                         Position  => I);
   --  
   --              -- k->second()
   --              All_Response_ID : Int64_Set := Int64_Pending_Auto_Req_Matrix.Element(Container => This.Pending_Auto_Req,
   --                                                                                   Position  => I);
   --           begin
   --  
   --              for Response_ID : constant Int64 in  All_Response_ID loop
   --  
   --                 if Int64_Route_Plan_Maps.Find(Container => THis.Route_Plan,
   --                                               Key       => Response_ID)
   --                 then
   --                    Is_Fulfilled := False;
   --                    Break;
   --                 end if;
   --              end loop;
   --  
   --  
   --              -- k++;
   --              Int64_Pending_Auto_Req_Matrix.Next(Container => THis.Pending_Auto_Req,
   --                                                 Position  => I);
   --  
   --              --   if (isFulfilled)
   --  
   --              if Is_Fulfilled then
   --  
   --                 -- SendMatrix(k->first);
   --                 This.Send_Matrix(Req_Id);
   --  
   --                 -- // finished with this automation request, discard
   --                 -- m_uniqueAutomationRequests.erase(k->first);
   --                 -- k = m_pendingAutoReq.erase(k);
   --                 Int64_Unique_Automation_Request_Maps.Delete(Container => This.Unique_Automation_Request,
   --                                                             Key       => Req_Id);
   --              end if;
   --           end;
   --  
   --        end loop;
   --  
   --     end Check_All_Route_Plans;
   --     
   --     procedure Check_All_Task_Option_Received(This : in out Route_Aggregator_Service)
   --     is
   --        C : Int64_Unique_Automation_Request_Maps.Cursor := Int64_Unique_Automation_Request_Maps.First(Container => THis.Unique_Automation_Request);
   --        procedure Build_Matrix_Requests(This : in out Route_Aggregator_Service;
   --                                        ReqID : Int64;
   --                                        Areq  : UniqueAutomationRequest_Acc);
   --        
   --        
   --     
   --     begin
   --        while Int64_Unique_Automation_Request_Maps.Has_Element(Container => This.Unique_Automation_Request,
   --                                                               Position  => C) loop
   --  
   --           declare
   --  
   --              -- // check that to see if all options from all tasks have been received for this request
   --              -- bool isAllReceived{true};
   --              Is_All_Received : Boolean := True;
   --  
   --              -- areqIter->second
   --              Request : UniqueAutomationRequest_Handler := Int64_Unique_Automation_Request_Maps.Element(Container => This.Unique_Automation_Request,
   --  
   --                                                                                                        Position  => C);
   --  
   --              -- areqIter->first
   --              Index_Request : Int64 := Int64_Unique_Automation_Request_Maps.Key(Container => This.Unique_Automation_Request,
   --                                                                                Position  => C)
   --              begin
   --  
   --                 -- for (size_t t = 0; t < areqIter->second->getOriginalRequest()->getTaskList().size(); t++)
   --                 for T in Unique_Automation_Request.Content.GetOriginalRequest.GetTaskList'Range loop
   --  
   --  
   --                    declare
   --                       -- int64_t taskId = areqIter->second->getOriginalRequest()->getTaskList().at(t);
   --                       Task_ID : Int64 := Unique_Automation_Request.Content.GetOriginalRequest.GetTaskList.Element(Index => T);
   --                    begin
   --  
   --                       -- if (m_taskOptions.find(taskId) == m_taskOptions.end())
   --                       if Int64_Task_Plan_Options_Maps.Find(Container => This.Task_Plan_Options,
   --                                                            Key       => Task_ID )
   --                       then
   --                          Is_All_Received := False;
   --                          Break;
   --                       end if;
   --                    end;
   --  
   --  
   --                 end loop;
   --  
   --                 --  if (isAllReceived)
   --                 if Is_All_Received then
   --  
   --  
   --                    -- BuildMatrixRequests(areqIter->first, areqIter->second);
   --                    This.Build_Matrix_Requests
   --                      (ReqID => Index_Request,
   --                       Areq  => Unique_Automation_Request );
   --                 end if
   --              end;
   --  
   --              --  areqIter++;
   --              Int64_Unique_Automation_Request_Maps.Next(Container => This.Unique_Automation_Request,
   --                                                        Position  => C);
   --           end loop;
   --        end Check_All_Task_Option_Received;
   --  
   --     
   --        --------------------------
   --        -- Handle_Route_Request --
   --        --------------------------
   --  
   --        procedure Handle_Route_Request
   --          (This         : in out Route_Aggregator_Service;
   --           Route_Request : RouteRequest_Acc)
   --        is
   --           use Int64_Vects;
   --           use Int64_Sets;
   --           use Ada.Containers;
   --        begin
   --  
   --           --  if (request->getVehicleID().empty())
   --           if (Route_Request.GetVehicleID.Length = 0) then
   --  
   --              --request->getVehicleID().reserve(m_entityStates.size());
   --              Route_Request.GetVehicleID.Reserve_Capacity(Capacity => This.Entity_State.Capacity);
   --  
   --              declare
   --                 C : Int64_Entity_State_Maps.Cursor := Int64_Entity_State_Maps.First(This.Entity_State);
   --              begin
   --                 -- for (const auto& v : m_entityStates)
   --                 while Int64_Entity_State_Maps.Has_Element(Container => This.Entity_State,
   --                                                           Position  => C) loop
   --  
   --                    -- request->getVehicleID().push_back(v.second->getID());
   --                    Route_Request.GetVehicleID.Append( Int64_Entity_State_Maps.Element
   --                                                       (Container => This.Entity_State,
   --                                                        Position  => C).Content.GetID);
   --                    Int64_Entity_State_Maps.Next(Container => This.Entity_State,
   --                                                 Position  => C);
   --                 end loop;
   --              end;
   --           end if;
   --  
   --           for Id_Indx in Route_Request.GetVehicleID.First_Index .. Route_Request.GetVehicleID.Last_Index  loop
   --  
   --  
   --              declare
   --  
   --                 Vehicles_Id : Int64 := Route_Request.GetVehicleID.Element(Index => Id_Indx);
   --                 -- std::shared_ptr<uxas::messages::route::RoutePlanRequest> planRequest(new uxas::messages::route::RoutePlanRequest);
   --                 Plan_Request : RoutePlanRequest;
   --  
   --  
   --                 --  m_pendingRoute[request->getRequestID()]
   --                 Pending_Route_Request : Int64_Set := Int64_Pending_Route_Matrix.Element(Container => This.Pending_Route,
   --                                                                                         Key       => Route_Request.GetRequestID);
   --  
   --  
   --              begin
   --  
   --                 -- planRequest->setAssociatedTaskID(request->getAssociatedTaskID());
   --                 -- planRequest->setIsCostOnlyRequest(request->getIsCostOnlyRequest());
   --                 -- planRequest->setOperatingRegion(request->getOperatingRegion());
   --                 -- planRequest->setVehicleID(vehicleId);
   --                 -- planRequest->setRequestID(m_routeRequestId);
   --                 Plan_Request.SetAssociatedTaskID (Route_Request.GetAssociatedTaskID);
   --                 Plan_Request.SetIsCostOnlyRequest(Route_Request.GetIsCostOnlyRequest);
   --                 Plan_Request.SetOperatingRegion  (Route_Request.GetOperatingRegion);
   --                 Plan_Request.SetVehicleID        (Vehicles_Id);
   --                 Plan_Request.SetRequestID        (Route_Request.GetRequestID);
   --  
   --                 --  m_pendingRoute[request->getRequestID()].insert(m_routeRequestId);
   --                 Int64_Sets.Insert(Container => Pending_Route_Request,
   --                                   New_Item  => This.Route_Request_ID);
   --  
   --                 This.Route_Request_ID := This.Route_Request_ID + 1;
   --  
   --  
   --                 for Indx in Route_Request.GetRouteRequests.First_Index .. Route_Request.GetRouteRequests.Last_Index loop
   --                    -- planRequest->getRouteRequests().push_back(r->clone());
   --                    Plan_Request.GetRouteRequests.Append(Route_Request.GetRouteRequests.Element(Indx));
   --                 end loop;
   --  
   --                 declare
   --                    -- std::shared_ptr<avtas::lmcp::Object> pRequest = std::static_pointer_cast<avtas::lmcp::Object>(planRequest);
   --                    P_Request :Avtas.Lmcp.Object.Object_Any := Avtas.Lmcp.Object.Object_Any
   --                      (Uxas.Messages.Route.Object.Object_Any(Plan_Request));
   --  
   --                 begin
   --  
   --  
   --                    --  if (m_groundVehicles.find(vehicleId) != m_groundVehicles.end())
   --                    if Int64_Sets.Contains(Container => This.Ground_Vehicles,
   --                                           Item      => Vehicles_Id)
   --                    then
   --  
   --                       -- if (m_fastPlan)
   --                       if This.Fast_Plan then
   --  
   --                          -- // short-circuit and just plan with straight line planner
   --                          -- EuclideanPlan(planRequest);
   --                          This.Euclidean_Plan(Route_Plan_Request => Plan_Request);
   --  
   --                       else
   --  
   --                          -- // send externally
   --                          -- sendSharedLmcpObjectLimitedCastMessage(uxas::common::MessageGroup::GroundPathPlanner(), pRequest);
   --                          This.Send_LMCP_Object_Limited_Cast_Message(CastAddress => GroundPathPlanner,
   --                                                                     Msg         => P_Request);
   --  
   --                       end if;
   --                    else
   --  
   --                       -- // send to aircraft planner
   --                       -- sendSharedLmcpObjectLimitedCastMessage(uxas::common::MessageGroup::AircraftPathPlanner(), pRequest);
   --                       This.Send_LMCP_Object_Limited_Cast_Message(CastAddress => AircraftPathPlanner,
   --                                                                  Msg         => P_Request);
   --                    end if;
   --                 end;
   --              end;
   --  
   --           end loop;
   --  
   --           if (This.Fast_Plan) then
   --              This.Check_All_Route_Plans;
   --           end if;
   --        end Handle_Route_Request;
   --  
   --  
   --        -- void EuclideanPlan(std::shared_ptr<uxas::messages::route::RoutePlanRequest>);
   --        procedure Euclidean_Plan(This             : in out Route_Aggregator_Service;
   --                                 Route_Plan_Request : RoutePlanRequest)
   --        is
   --           -- uxas::common::utilities::CUnitConversions flatEarth;
   --           -- int64_t regionId = request->getOperatingRegion();
   --           -- int64_t vehicleId = request->getVehicleID();
   --           -- int64_t taskId = request->getAssociatedTaskID();
   --           Flat_Earth : Unit_Conversions;
   --           Region_ID   : Int64 := Route_Plan_Request.GetOperatingRegion;
   --           Vehicles_ID : Int64 := Route_Plan_Request.GetVehicleID;
   --           Task_ID     : Int64 := Route_Plan_Request.GetAssociatedTaskID;
   --  
   --           -- double speed = 1.0; // default if no speed available
   --           Speed  : Long_Float := 1.0;
   --  
   --           --  auto response = std::shared_ptr<uxas::messages::route::RoutePlanResponse>(new uxas::messages::route::RoutePlanResponse);
   --           Response : RoutePlanResponse;
   --        begin
   --           --  if (m_entityConfigurations.find(vehicleId) != m_entityConfigurations.end())
   --           if Int64_Entity_Configuration_Maps.Contains(Container => This.Entity_Configuration,
   --                                                       Key       => Vehicles_ID);
   --           then
   --  
   --              --   double speed = m_entityConfigurations[vehicleId]->getNominalSpeed();
   --              Speed :=Int64_Entity_Configuration_Maps.Element(Container => This.Entity_Configuration,
   --                                                              Position  => Vehicles_ID).Content.GetNominalSpeed;
   --  
   --              -- if (speed < 1e-2)
   --              if (Speed < 0.02) then
   --                 --  speed = 1.0; // default to 1 if too small for division
   --                 Speed := 1.0;
   --              end if;
   --           end if;
   --  
   --           Response.SetAssociatedTaskID(Task_ID);
   --           Response.SetOperatingRegion(Region_ID);
   --           Response.SetVehicleID(Vehicles_ID);
   --           Response.SetResponseID(Route_Plan_Request.GetRequestID);
   --  
   --           -- for (size_t k = 0; k < request->getRouteRequests().size(); k++)
   --           for K in Route_Plan_Request.GetRouteRequests'Range loop
   --              declare
   --                 -- uxas::messages::route::RouteConstraints* routeRequest = request->getRouteRequests().at(k);
   --                 Route_Request : My_RouteConstraints := Wrap(Route_Plan_Request.GetRouteRequests.Element(K));
   --  
   --                 Route_ID : Int64 := Route_Request.GetRouteID;
   --  
   --  
   --                 -- Start_Point : Visibility.Point;
   --                 -- End_Point : Visibility.Point;
   --                 Start_North  : Long_Float;
   --                 Start_East   : Long_Float;
   --                 End_North    : Long_Float;
   --                 End_East     : Long_Float;
   --  
   --                 -- uxas::messages::route::RoutePlan* plan = new uxas::messages::route::RoutePlan;
   --                 Plan : RoutePlan;
   --  
   --                 Line_Dist : Long_Float;
   --                 Pair_Response_Route :  Pair_Int64_Route_Plan;
   --  
   --  
   --              begin
   --                 Plan.SetRouteID(Route_ID);
   --  
   --                 -- flatEarth.ConvertLatLong_degToNorthEast_m(routeRequest->getStartLocation()->getLatitude(), routeRequest->getStartLocation()->getLongitude(), north, east);
   --                 Flat_Earth.Convert_Lag_Long_DEG_To_North_East_M
   --                   (D_Latitude_DEG  => Route_Request.GetStartLocation.GetLatitude,
   --                    D_Longitude_DEG => Route_Request.GetStartLocation.GetLatitude,
   --                    D_North_M       => Start_North,
   --                    D_East_M        => Start_East);
   --                 -- Start_Point.set_X(Start_East);
   --                 -- Start_Point.set_Y(Start_North);
   --  
   --  
   --  
   --                 -- flatEarth.ConvertLatLong_degToNorthEast_m(routeRequest->getEndLocation()->getLatitude(), routeRequest->getEndLocation()->getLongitude(), north, east);
   --                 Flat_Earth.Convert_Lag_Long_DEG_To_North_East_M
   --                   (D_Latitude_DEG  =>Route_Request.GetEndLocation.GetLatitude,
   --                    D_Longitude_DEG => Route_Request.GetEndLocation.GetLatitude,
   --                    D_North_M       => End_North,
   --                    D_East_M        => End_East);
   --                 -- End_Point.Set_X(End_East );
   --                 -- End_Point.Set_Y(End_North);
   --  
   --                 -- -- double linedist = VisiLibity::distance(startPt, endPt);
   --                 -- Line_Dist := Distance(Start_Point , End_Point);
   --                 Line_Dist := Sqrt( ((End_North - Start_North)**2.0) + ((End_East - Start_East)**2.0));
   --  
   --                 Plan.SetRouteCost( Line_Dist / Speed * 1000);
   --  
   --                 --  m_routePlans[routeId] = std::make_pair(request->getRequestID(), std::shared_ptr<uxas::messages::route::RoutePlan>(plan));
   --                 Int64_Pair_Int64_Route_Plan_Maps.Insert
   --                   (Container => This.Route_Plan,
   --                    Key       => Route_ID,
   --                    New_Item  =>  Pair_Int64_Route_Plan'(Reponse_ID          => Route_Plan_Request.GetRequestID ,
   --                                                         Returned_Route_Plan => Plan ));
   --  
   --              end;
   --           end loop;
   --           -- m_routePlanResponses[response->getResponseID()] = response;
   --           Int64_Route_Plan_Responses_Maps.Insert
   --             (Container => Tis.Route_Plan_Responses,
   --              Key       => Response.GetResponseID,
   --              New_Item  => Response);
   --  
   --        end Euclidean_Plan;

end UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK;
