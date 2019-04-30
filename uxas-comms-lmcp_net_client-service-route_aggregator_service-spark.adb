with UxAS.Messages.Route.RoutePlan;

with Uxas.Messages.Route.RouteResponse; use Uxas.Messages.Route.RouteResponse;
with Ada.Numerics.Long_Elementary_Functions; use  Ada.Numerics.Long_Elementary_Functions;
with Afrl.Cmasi.AutomationRequest; use Afrl.Cmasi.AutomationRequest;

with Ada.Text_IO; use Ada.Text_IO;

with UxAS.Messages.Lmcptask.AssignmentCostMatrix; use UxAS.Messages.Lmcptask.AssignmentCostMatrix;
with UxAS.Messages.Lmcptask.UniqueAutomationRequest.SPARK_Boundary; use UxAS.Messages.Lmcptask.UniqueAutomationRequest.SPARK_Boundary;
with UxAS.Messages.Lmcptask.TaskOptionCost; use UxAS.Messages.Lmcptask.TaskOptionCost; 

with Afrl.Cmasi.Enumerations; use Afrl.Cmasi.Enumerations;

with Afrl.Cmasi.ServiceStatus; use Afrl.Cmasi.ServiceStatus;
with Afrl.Cmasi.KeyValuePair;  use Afrl.Cmasi.KeyValuePair;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Afrl.Cmasi.Location3D.Spark_Boundary; use Afrl.Cmasi.Location3D.Spark_Boundary;

with UxAS.Common.Utilities.Unit_Conversions; use UxAS.Common.Utilities.Unit_Conversions; 
with Ada.Containers.Formal_Vectors;
with UxAS.Messages.Route.RouteConstraints.Spark_Boundary; use UxAS.Messages.Route.RouteConstraints.Spark_Boundary;

with Common_Formal_Containers; use Common_Formal_Containers;


with Ada.Containers; use Ada.Containers;
with Ada.Containers.Vectors;

with Afrl.Cmasi.Location3D; use Afrl.Cmasi.Location3D;
with Uxas.Messages.Lmcptask.TaskOption; use Uxas.Messages.Lmcptask.TaskOption;

with Ada.Containers.Formal_Hashed_Maps;

with Uxas.Messages.Lmcptask.PlanningState; use Uxas.Messages.Lmcptask.PlanningState;


package body UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK with SPARK_Mode is
   
   procedure Build_Matrix_Requests(This  : in out Route_Aggregator_Service;
                                   ReqID : in Int64;
                                   Areq  : in UniqueAutomationRequest_Acc)
     --      // All options corresponding to current automation request have been received
     --      // now make 'matrix' requests (all task options to all other task options)
     --      // [but only if options haven't already been sent??]
     --  
     --      // Proceedure:
     --      //  1. Create new 'pending' data structure for all routes that will fulfill this request
     --      //  2. For each vehicle, create requests for:
     --      //       a. initial position to each task option
     --      //       b. task/option to task/option
     --      //       c. associate routeID with task options in m_routeTaskPairing
     --      //       d. push routeID onto pending list
     --      //  3. Send requests to proper planners
   
   is
      package Vect_Plan_Request_P is new Ada.Containers.Formal_Vectors
        (Index_Type   => Natural,
         Element_Type => RoutePlanRequest);
      
      Vect_Plan_Request_P_Commun_Max_Capacity : constant := 200; -- arbitrary

      subtype Vect_Plan_Request is Vect_Plan_Request_P.Vector
        (Vect_Plan_Request_P_Commun_Max_Capacity);
      
      Send_Air_Plan_Request    : Vect_Plan_Request;
      Send_Ground_Plan_Request : Vect_Plan_Request; 
      
      
     
   begin
      
      if  Areq.GetOriginalRequest.GetEntityList.Is_Empty then
         
         for Entity of This.Entity_State loop
            Vect_Int64.Append(Source   => Areq.GetOriginalRequest.GetEntityList,
                              New_Item => Entity.GetID);
         end loop;
         
      end if;
      
      
      for Vehicle_ID of Areq.GetOriginalRequest.GetEntityList.all loop
      
         declare
            Vehicles : EntityState;
            Contains_Vehicles : Boolean := Int64_Entity_State_Maps.Contains (Container => This.Entity_State,
                                                                             Index  => Vehicle_ID);
            Start_Heading_DEG : Real32 := 0.0;
            
            Start_Location : My_Location3D_Any;
            
            Is_Foud_Planning_State : Boolean := False;
               
            package Vect_Task_Option_P is new Ada.Containers.Formal_Vectors
              (Index_Type   => Natural,
               Element_Type => TaskOption);
      
            Vect_Task_Option_P_Commun_Max_Capacity : constant := 200; -- arbitrary

            subtype Vect_Task_Option is Vect_Task_Option_P.Vector
              (Vect_Plan_Request_P_Commun_Max_Capacity);
      
            Task_Option_List : Vect_Task_Option;
            use Int64_Task_Plan_Options_Maps;
         begin
            
            
            for Planning_State : PlanningState_Acc of Areq.GetPlanningStates.all loop
         
               if Planning_State.GetEntityID = Vehicle_ID then
                  Start_Location := Wrap(Planning_State.GetPlanningPosition);
                  Start_Heading_DEG := Planning_State.GetPlanningHeading;
                  Is_Foud_Planning_State := True;
                  exit;
               end if;
            end loop;
            
            
            if (Is_Foud_Planning_State and Contains_Vehicles) then
               Vehicles := Int64_Entity_State_Maps.Element(This.Entity_State,
                                                           Vehicle_ID).Content;
               
               for Task_ID of Areq.GetOriginalRequest.GetTaskList.all loop
                  if Contains(This.Task_Plan_Options,
                              Task_ID) then
                     
                     for Option of Element(This.Task_Plan_Options,
                                           Task_ID).Content.GetOptions.all loop
                        
                        
                        if Vect_Int64.Is_Empty(Option.GetEligibleEntities) 
                          and Vect_Int64.Find(Container => Option.GetEligibleEntites,
                                              Item      => Vehicle_ID) then
                           Vect_Task_Option_P.Append(Source   => Task_Option_List,
                                                     New_Item => Option); -- TODO clone here
                        end if;
                     end loop;
                     
                  end if;
               end loop;
            end if;
         end;
      end loop;
      
                 
            
               
                        
                          
                  
      
             
      
      
   end Build_Matrix_Requests;
      

   -- void EuclideanPlan(std::shared_ptr<uxas::messages::route::RoutePlanRequest>);
   procedure Euclidean_Plan(This             : in out Route_Aggregator_Service;
                            Route_Plan_Request : RoutePlanRequest)
        
   is
      -- uxas::common::utilities::CUnitConversions flatEarth;
      -- int64_t regionId = request->getOperatingRegion();
      -- int64_t vehicleId = request->getVehicleID();
      -- int64_t taskId = request->getAssociatedTaskID();
      Region_ID   : Int64 := Route_Plan_Request.GetOperatingRegion;
      Vehicles_ID : Int64 := Route_Plan_Request.GetVehicleID;
      Task_ID     : Int64 := Route_Plan_Request.GetAssociatedTaskID;
      
      -- double speed = 1.0; // default if no speed available
      Speed  : Long_Float := 1.0;
      
      --  auto response = std::shared_ptr<uxas::messages::route::RoutePlanResponse>(new uxas::messages::route::RoutePlanResponse);
      Response : RoutePlanResponse_Acc := new RoutePlanResponse;
   begin
      --  if (m_entityConfigurations.find(vehicleId) != m_entityConfigurations.end())
      if Int64_Entity_Configuration_Maps.Contains(Container => This.Entity_Configuration,
                                                  Key       => Vehicles_ID)
      then
      
         --   double speed = m_entityConfigurations[vehicleId]->getNominalSpeed();
         Speed := Long_Float(Int64_Entity_Configuration_Maps.Element(Container => This.Entity_Configuration,
                                                                     Key       => Vehicles_ID).Content.GetNominalSpeed);
      
         -- if (speed < 1e-2)
         if (Speed < 0.02) then
            --  speed = 1.0; // default to 1 if too small for division
            Speed := 1.0;
         end if;
      end if;
      
      Response.SetAssociatedTaskID(Task_ID);
      Response.SetOperatingRegion(Region_ID);
      Response.SetVehicleID(Vehicles_ID);
      Response.SetResponseID(Route_Plan_Request.GetRequestID);
      
      -- for (size_t k = 0; k < request->getRouteRequests().size(); k++)
      for K of Route_Plan_Request.GetRouteRequests.all loop
         declare
            -- uxas::messages::route::RouteConstraints* routeRequest = request->getRouteRequests().at(k);
            Route_Request : My_RouteConstraints := Wrap(K.all);
      
            Route_ID : Int64 := Get_RouteID(Route_Request);
      
      
            -- Start_Point : Visibility.Point;
            -- End_Point : Visibility.Point;
            Start_North  : Long_Float;
            Start_East   : Long_Float;
            End_North    : Long_Float;
            End_East     : Long_Float;
      
            -- uxas::messages::route::RoutePlan* plan = new uxas::messages::route::RoutePlan;
            Plan : RoutePlan_Acc := new RoutePlan;
      
            Line_Dist : Long_Float;
            Pair_Response_Route :  Pair_Int64_Route_Plan;
      
      
         begin
            Plan.SetRouteID(Route_ID);
      
            -- flatEarth.ConvertLatLong_degToNorthEast_m(routeRequest->getStartLocation()->getLatitude(), routeRequest->getStartLocation()->getLongitude(), north, east);
            Convert_Lat_Long_DEG_To_North_East_M
              (Latitude_DEG  => Long_Float(Get_Latitude  (Get_StartLocation(Route_Request))),
               Longitude_DEG => Long_Float(Get_Longitude (Get_StartLocation(Route_Request))),
               North_M       => Start_North,
               East_M        => Start_East);
            -- Start_Point.set_X(Start_East);
            -- Start_Point.set_Y(Start_North);
      
      
      
            -- flatEarth.ConvertLatLong_degToNorthEast_m(routeRequest->getEndLocation()->getLatitude(), routeRequest->getEndLocation()->getLongitude(), north, east);
            Convert_Lat_Long_DEG_To_North_East_M
              (Latitude_DEG  => Long_Float(Get_Latitude  (Get_EndLocation(Route_Request))),
               Longitude_DEG => Long_Float(Get_Longitude (Get_EndLocation(Route_Request))),
               North_M       => End_North,
               East_M        => End_East);
            -- End_Point.Set_X(End_East );
            -- End_Point.Set_Y(End_North);
      
            -- -- double linedist = VisiLibity::distance(startPt, endPt);
            -- Line_Dist := Distance(Start_Point , End_Point);
            Line_Dist := Sqrt( ((End_North - Start_North)**2.0) + ((End_East - Start_East)**2.0));
      
            Plan.SetRouteCost( Int64( Line_Dist / Speed * 1000.0));
      
            --  m_routePlans[routeId] = std::make_pair(request->getRequestID(), std::shared_ptr<uxas::messages::route::RoutePlan>(plan));
            Int64_Pair_Int64_Route_Plan_Maps.Insert
              (Container => This.Route_Plan,
               Key       => Route_ID,
               New_Item  =>  Pair_Int64_Route_Plan'(Reponse_ID          => Route_Plan_Request.GetRequestID ,
                                                    Returned_Route_Plan => Plan ));
      
         end;
      end loop;
      -- m_routePlanResponses[response->getResponseID()] = response;
      Int64_Route_Plan_Responses_Maps.Insert(Container => This.Route_Plan_Responses,
                                             Key       => Response.GetResponseID,
                                             New_Item  => Route_Plan_Responses_Holder'(
                                               Content => RoutePlanResponse_Any(Response)));
      
   end Euclidean_Plan;
            
   
   
   -- void SendRouteResponse(int64_t);
   procedure Send_Route_Reponse ( This : in out Route_Aggregator_Service;
                                  RouteKey : Int64)
   is 
      Response  : constant RouteResponse_Acc := new RouteResponse;
      RouteList : constant Vect_RoutePlanResponse_Acc_Acc := Response.GetRoutes;
      Exepcted_Plan_Response_IDs : constant Int64_Set := Int64_Pending_Route_Matrix.Element(This.Pending_Route,
                                                                                            RouteKey);
         
   begin
           
      --  response->setResponseID(routeKey);
      Response.SetResponseID(RouteKey);
         
      --  for (auto& rId : m_pendingRoute[routeKey])
      for Plan_Reponse_Id of Exepcted_Plan_Response_IDs loop
            
         --  auto plan = m_routePlanResponses.find(rId);
         --  if (plan != m_routePlanResponses.end())
         if Int64_Route_Plan_Responses_Maps.Contains(This.Route_Plan_Responses,
                                                     Plan_Reponse_Id) then
            declare
               Plan_Acc : RoutePlanResponse_Acc;
                     
            begin
               Plan_Acc := RoutePlanResponse_Acc( Int64_Route_Plan_Responses_Maps.Element(This.Route_Plan_Responses,
                                                  Plan_Reponse_Id).Content);
                     
               RouteList.Append(Plan_Acc);   -- clone here
                  
                  
                  
               --  // delete all individual routes from storage
               --  for (auto& i : plan->second->getRouteResponses())
               for Route_Reponse of  Plan_Acc.GetRouteResponses.all loop
                       
                  --  M_RoutePlans.Erase(I->GetRouteID());
                  Int64_Pair_Int64_Route_Plan_Maps.Delete(This.Route_Plan,
                                                          Route_Reponse.GetRouteID);
               end loop;
                  
                  
                  
               --   m_routePlanResponses.erase(plan);   
               Int64_Route_Plan_Responses_Maps.Delete(This.Route_Plan_Responses,
                                                      Plan_Reponse_Id);
            end;
         end if;
      end loop;
            
      --  sendSharedLmcpObjectBroadcastMessage(pResponse);
      This.Send_LMCP_Object_Broadcast_Message(Object_Any(Response));
            
        
            
   end Send_Route_Reponse;
      
   
   
   
      
   procedure Check_All_Route_Plans(This : in out Route_Aggregator_Service)
   is
      C : Int64_Pending_Route_Matrix.Cursor :=
        Int64_Pending_Route_Matrix.First(Container => This.Pending_Route);
   
      I : Int64_Pending_Auto_Req_Matrix.Cursor :=
        Int64_Pending_Auto_Req_Matrix.First(Container => THis.Pending_Auto_Req);
      
      
      --  Void SendMatrix(Int64_T);
      procedure Send_Matrix( This : in out Route_Aggregator_Service;
                             AutoKey : Int64);
        
      procedure Send_Matrix( This : in out Route_Aggregator_Service;
                             AutoKey : Int64)
      is
         --   auto matrix = std::shared_ptr<uxas::messages::task::AssignmentCostMatrix>(new uxas::messages::task::AssignmentCostMatrix);
         Matrix :  AssignmentCostMatrix_Acc := new AssignmentCostMatrix;
         
         --   auto& areq = m_uniqueAutomationRequests[autoKey];
         Areq   : constant UniqueAutomationRequest'Class := 
           Int64_Unique_Automation_Request_Maps.Element(Container => This.Unique_Automation_Request,
                                                        Key       => AutoKey).Content.all;
         Route_Not_Found : Unbounded_String := To_Unbounded_String("");
                  
         Service_Status  : ServiceStatus_Acc;
         
         -- auto keyValuePair = new afrl::cmasi::KeyValuePair;
         Key_Pair_Acc    : KeyValuePair_Acc;
      begin
         
         --   for (auto& rId : m_pendingAutoReq[autoKey])
         for R_Id of Int64_Pending_Auto_Req_Matrix.Element(Container => This.Pending_Auto_Req,
                                                           Key       => AutoKey) loop 
            
            --  auto plan = m_routePlans.find(rId);
            --  if (plan != m_routePlans.end())
            if Int64_Pair_Int64_Route_Plan_Maps.Contains(This.Route_Plan,
                                                         R_ID)
            then
               declare
                  --  auto taskpair = m_routeTaskPairing.find(rId);
                  Plan : Pair_Int64_Route_Plan := Int64_Pair_Int64_Route_Plan_Maps.Element(This.Route_Plan,
                                                                                           R_ID);
               begin
                 
                  -- if (taskpair != m_routeTaskPairing.end())
                  if Int64_Aggregator_Task_Option_Pair_Maps.Contains(Container => This.Route_Task_Pairing,
                                                                     Key       => R_ID)
                  then
                     declare
                        Task_Pair :AggregatorTaskOptionPair := Int64_Aggregator_Task_Option_Pair_Maps.Element( This.Route_Task_Pairing,
                                                                                                               R_Id);
                             
                        -- auto toc = new uxas::messages::task::TaskOptionCost;                                                                                      
                        Task_Option_Cost : TaskOptionCost_Acc := new TaskOptionCost;
                     begin
                        
                        -- if (plan->second.second->getRouteCost() < 0)
                        if (Plan.Returned_Route_Plan.GetRouteCost < 0)
                        then
                           Route_Not_Found := To_Unbounded_String("V[" & Task_Pair.VehicleId'Image & "](" & Task_Pair.PrevTaskId'Image  &  ","
                                                                  & Task_Pair.PrevTaskOption'Image  & ")-(" & Task_Pair.TaskId'Image  & "," & Task_Pair.TaskOption'Image  & ")") ;
                        end if;
                                 
                                 
                        Task_Option_Cost.SetDestinationTaskID(Task_Pair.TaskId);
                        Task_Option_Cost.SetDestinationTaskOption(Task_Pair.TaskOption);
                        Task_Option_Cost.SetIntialTaskID(Task_Pair.PrevTaskId);
                        Task_Option_Cost.SetIntialTaskOption(Task_Pair.PrevTaskOption);
                        Task_Option_Cost.SetTimeToGo(Plan.Returned_Route_Plan.GetRouteCost);
                        Task_Option_Cost.SetVehicleID(Task_Pair.VehicleId);
                       
                        --  matrix->getCostMatrix().push_back(toc);
                        Matrix.GetCostMatrix.Append(New_Item => Task_Option_Cost);
                        
                        -- m_routeTaskPairing.erase(taskpair); 
                        Int64_Aggregator_Task_Option_Pair_Maps.Delete(This.Route_Task_Pairing,
                                                                      R_Id);
                     end;
                  end if;
                  --  // Clear out Memory
                  --  M_RoutePlanResponses.Erase(Plan->Second.First);
                  --  M_RoutePlans.Erase(Plan);
                           
                  Int64_Route_Plan_Responses_Maps.Delete(This.Route_Plan_Responses,
                                                         Plan.Reponse_ID);
                  Int64_Pair_Int64_Route_Plan_Maps.Delete(This.Route_Plan,
                                                          R_ID);
               end;
            end if;
         end loop;
         
         --  // Send The Total Cost Matrix
         --  Std::Shared_Ptr<Avtas::Lmcp::Object> PResponse = Std::Static_Pointer_Cast<Avtas::Lmcp::Object>(Matrix);
         --  SendSharedLmcpObjectBroadcastMessage(PResponse);
         This.Send_Shared_LMCP_Object_Broadcast_Message(Object_Any(Matrix));
         
    
         --  // clear out old options
         --  M_TaskOptions.Clear();
         Int64_Task_Plan_Options_Maps.Clear(This.Task_Plan_Options);
                  
         
         
         Service_Status.SetStatusType(Afrl.Cmasi.Enumerations.Information);
         --  if (!routesNotFound.str().empty())
         if Length(Route_Not_Found) > 0 then
                     
            
            Key_Pair_Acc.SetKey(To_Unbounded_String("RoutesNotFound - [VehicleId](StartTaskId,StartOptionId)-(EndTaskId,EndOptionId)"));
                     
            Key_Pair_Acc.SetValue(Route_Not_Found);
            Service_Status.GetInfo.Append(Key_Pair_Acc);
            
           
            Put(To_String("RoutesNotFound - [VehicleId](StartTaskId,StartOptionId)-(EndTaskId,EndOptionId) :: " & Route_Not_Found));
                  
         else
           
            Key_Pair_Acc.SetKey(To_Unbounded_String("AssignmentMatrix - full"));
            
            Service_Status.GetInfo.Append(Key_Pair_Acc);
            
         end if;
         
         --  sendSharedLmcpObjectBroadcastMessage(serviceStatus);
         THis.Send_LMCP_Object_Broadcast_Message(Object_Any(Service_Status));
         
         
      end Send_Matrix;
            
   begin
               
               
               
               
               
               
               
                       
                      
         
                  
   
      --  // check pending route requests
      -- auto i = m_pendingRoute.begin();
      -- while (i != m_pendingRoute.end())
   
      while Int64_Pending_Route_Matrix.Has_Element(Container => This.Pending_Route ,
                                                   Position  => C)
      loop
         declare
            
   
            -- i->first()
            Route_Id : constant Int64 :=
              Int64_Pending_Route_Matrix.Key(Container => This.Pending_Route,
                                             Position  => C);
   
            -- i->second()
            Liste_Route : constant  Int64_Set :=
              Int64_Pending_Route_Matrix.Element(Container => THis.Pending_Route,
                                                 Position  => C);
           
            -- bool isFulfilled = true;
            Is_Fulfilled : constant Boolean := (for all Id_Request of Liste_Route => 
                                                  Int64_Route_Plan_Responses_Maps.Contains(Container => This.Route_Plan_Responses,
                                                                                           Key       => Id_Request));
         begin
   
   
            Int64_Pending_Route_Matrix.Next(Container => THis.Pending_Route,
                                            Position  => C);
            if (Is_Fulfilled) then
 
               Send_Route_Reponse(This     => This,
                                  RouteKey => Route_Id);
               
               Int64_Pending_Route_Matrix.Delete(Container => This.Pending_Route,
                                                 Key       => Route_Id);
            end if;
         end;
      end loop;
   
   
      -- // check pending automation requests
      -- auto k = m_pendingAutoReq.begin();
      -- while (k != m_pendingAutoReq.end())
      while Int64_Pending_Auto_Req_Matrix.Has_Element(Container => THis.Pending_Auto_Req,
                                                      Position  => I)
      loop
         declare
   
            -- k->first()
            Req_Id : Int64 := Int64_Pending_Auto_Req_Matrix.Key(Container => THis.Pending_Auto_Req,
                                                                Position  => I);
   
            -- k->second()
            All_Response_ID : Int64_Set := Int64_Pending_Auto_Req_Matrix.Element(Container => This.Pending_Auto_Req,
                                                                                 Position  => I);
            
            Is_Fulfilled : Boolean := (for all Response_ID of All_Response_ID =>
                                         Int64_Pair_Int64_Route_Plan_Maps.Contains(Container => THis.Route_Plan,
                                                                                   Key       => Response_ID));
         begin
           
   
            Int64_Pending_Auto_Req_Matrix.Next(Container => THis.Pending_Auto_Req,
                                               Position  => I);
   

            if Is_Fulfilled then
   
               -- SendMatrix(k->first);
               Send_Matrix(This,Req_Id);
   
               -- // finished with this automation request, discard
               -- m_uniqueAutomationRequests.erase(k->first);
               -- k = m_pendingAutoReq.erase(k);
               Int64_Unique_Automation_Request_Maps.Delete(Container => This.Unique_Automation_Request,
                                                           Key       => Req_Id);
            end if;
         end;
   
      end loop;
      
     
   
   end Check_All_Route_Plans;
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


end UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK;
