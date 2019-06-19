with Ada.Numerics.Long_Elementary_Functions;                     use Ada.Numerics.Long_Elementary_Functions;
with Ada.Strings.Unbounded;                                      use Ada.Strings.Unbounded;
with Ada.Containers;                                             use Ada.Containers;
with Ada.Text_IO;                                                use Ada.Text_IO;
with Ada.Containers.Formal_Vectors;

with Common_Formal_Containers;                                   use Common_Formal_Containers;

with UxAS.Messages.Lmcptask.TaskOption;                          use UxAS.Messages.Lmcptask.TaskOption;
with UxAS.Messages.Lmcptask.TaskOptionCost;                      use UxAS.Messages.Lmcptask.TaskOptionCost;
with UxAS.Messages.Lmcptask.AssignmentCostMatrix;                use UxAS.Messages.Lmcptask.AssignmentCostMatrix;
with UxAS.Messages.Lmcptask.PlanningState.SPARK_Boundary;        use UxAS.Messages.Lmcptask.PlanningState.SPARK_Boundary;

with UxAS.Messages.Route.RoutePlan;

with UxAS.Messages.Route.RouteResponse;                          use UxAS.Messages.Route.RouteResponse;
with UxAS.Messages.Route.RouteResponse.SPARK_Boundary;           use UxAS.Messages.Route.RouteResponse.SPARK_Boundary;
with UxAS.Messages.Route.RouteConstraints.SPARK_Boundary;        use UxAS.Messages.Route.RouteConstraints.SPARK_Boundary;
with UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Vects;  use UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Vects;

with UxAS.Messages.Lmcptask.TaskOption.Spark_Boundary;           use UxAS.Messages.Lmcptask.TaskOption.Spark_Boundary;
with UxAS.Messages.Lmcptask.TaskPlanOptions.Spark_Boundary;      use UxAS.Messages.Lmcptask.TaskPlanOptions.Spark_Boundary;
with UxAS.Messages.Lmcptask.TAskOptionCost.SPARK_Boundary;       use UxAS.Messages.Lmcptask.TAskOptionCost.SPARK_Boundary;
with UxAS.Messages.Lmcptask.AssignmentCostMatrix.SPARK_Boundary; use UxAS.Messages.Lmcptask.AssignmentCostMatrix.SPARK_Boundary;
with UxAS.Common.Utilities.Unit_Conversions;                     use UxAS.Common.Utilities.Unit_Conversions; 

with UxAS.Common.String_Constant.Message_Group;                  use UxAS.Common.String_Constant.Message_Group;

with Afrl.Cmasi.Enumerations;                                    use Afrl.Cmasi.Enumerations;
with Afrl.Cmasi.ServiceStatus;                                   use Afrl.Cmasi.ServiceStatus;
with Afrl.Cmasi.KeyValuePair;                                    use Afrl.Cmasi.KeyValuePair;
with Afrl.Cmasi.Location3D;                                      use Afrl.Cmasi.Location3D;
with Afrl.Cmasi.AutomationRequest;                               use Afrl.Cmasi.AutomationRequest;
with Afrl.Cmasi.Location3D.Spark_Boundary;                       use Afrl.Cmasi.Location3D.Spark_Boundary;
with Afrl.Cmasi.ServiceStatus.SPARK_Boundary;                    use Afrl.Cmasi.ServiceStatus.SPARK_Boundary;
use  Afrl.Cmasi.AutomationRequest.Vect_Int64;

with Convert;   




package body UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK with SPARK_Mode is
   
   
   procedure Lemma_Check_Same_Entity_State_Identity (This : in Entity_State_Map ) is null;
   procedure Lemma_Check_Same_Entity_State_Commutativity (X, Y : in Entity_State_Map ) is null;
   procedure Lemma_Check_Same_Entity_State_Associativity (X, Y, Z : in Entity_State_Map ) is null;
   
   procedure Lemma_Same_Route_Aggregator_Identity (This : in Route_Aggregator_Service ) is null;   
   procedure Lemma_Same_Route_Aggregator_Validity (X, Y : in Route_Aggregator_Service ) is null;
   procedure Lemma_Same_Route_Aggregator_Commutativity (X, Y    : in Route_Aggregator_Service ) is null;
   procedure Lemma_Same_Route_Aggregator_Associativity (X, Y, Z : in Route_Aggregator_Service ) is null;
   procedure Lemma_Ceck_Route_Plan_Reference_Insert ( Route_Plan : in Pair_Int64_Route_Plan_Map;
                                                      Old_Pending_Route, New_Pending_Route : in Pending_Route_Matrix;
                                                      Old_Route_Plan_Rep, New_Route_Plan_Rep : in Route_Plan_Responses_Map) 
   is
   begin
      pragma Assert (for all Cursor in Route_Plan
                     => Check_Route_Plan_Sub (Element (Route_Plan, Cursor), Old_Pending_Route, Old_Route_Plan_Rep, Key (Route_Plan, Cursor))
                     and Contains (New_Pending_Route,  Element (Route_Plan, Cursor).Reponse_ID)
                     and Contains (New_Route_Plan_Rep, Element (Route_Plan, Cursor).Reponse_ID)
                     and Check_Route_Plan_Sub (Element (Route_Plan, Cursor), New_Pending_Route, New_Route_Plan_Rep, Key (Route_Plan, Cursor)));
   end Lemma_Ceck_Route_Plan_Reference_Insert;
   procedure Lemma_Same_Route_Aggregator (X : in Route_Aggregator_Service) is null;
                       
   



     
   --     package My_Task_Option_Vects is new Ada.Containers.Formal_Vectors
   --       (Index_Type   => Natural,
   --        Element_Type => My_TaskOption);
   --  
   --     ---------------------------
   --     -- Build_Matrix_Requests --
   --     ---------------------------
   --  
   --  
   --     procedure Build_Matrix_Requests (This  : in out Route_Aggregator_Service;
   --                                      ReqID : Int64;
   --                                      Areq  : My_UniqueAutomationRequest)
   --  
   --       --      // All options corresponding to current automation request have been received
   --       --      // now make 'matrix' requests (all task options to all other task options)
   --       --      // [but only if options haven't already been sent??]
   --       --
   --       --      // Proceedure:
   --       --      //  1. Create new 'pending' data structure for all routes that will fulfill this request
   --       --      //  2. For each vehicle, create requests for:
   --       --      //       a. initial position to each task option
   --       --      //       b. task/option to task/option
   --       --      //       c. associate routeID with task options in m_routeTaskPairing
   --       --      //       d. push routeID onto pending list
   --       --      //  3. Send requests to proper planners
   --  
   --     is
   --        
   --        procedure My_Send_Shared_LMCP_Object_Limited_Cast_Message
   --          (This : in out Route_Aggregator_Service;
   --           Cast_Address : String;
   --           Request : My_RoutePlanRequest) with 
   --          Post => (if All_Requests_Valid (This)'Old then All_Requests_Valid (This)) ;
   --  
   --        procedure My_Send_Shared_LMCP_Object_Limited_Cast_Message
   --          (This : in out Route_Aggregator_Service;
   --           Cast_Address : String;
   --           Request : My_RoutePlanRequest) with
   --          SPARK_Mode => Off
   --        is
   --           Request_Acc : constant RoutePlanRequest_Acc := new RoutePlanRequest;
   --        begin
   --           Request_Acc.all := Unwrap (Request);
   --           This.Send_Shared_LMCP_Object_Limited_Cast_Message (Cast_Address,
   --                                                              Object_Any (Request_Acc)); 
   --        end My_Send_Shared_LMCP_Object_Limited_Cast_Message;
   --        
   --  
   --        package My_Plan_Request_Vects is new Ada.Containers.Formal_Vectors
   --          (Index_Type   => Natural,
   --           Element_Type => My_RoutePlanRequest);
   --        use My_Plan_Request_Vects;
   --  
   --        My_Plan_Request_Vects_Commun_Max_Capacity : constant := 200; -- arbitrary
   --  
   --        subtype My_Plan_Request_Vect is My_Plan_Request_Vects.Vector
   --          (My_Plan_Request_Vects_Commun_Max_Capacity);
   --  
   --        Send_Air_Plan_Request    : My_Plan_Request_Vect := My_Plan_Request_Vects.Empty_Vector;
   --        Send_Ground_Plan_Request : My_Plan_Request_Vect := My_Plan_Request_Vects.Empty_Vector;
   --        use Int64_Vects;
   --  
   --        Entity_List : Int64_Vect := Get_EntityList_From_OriginalRequest (Request => Areq);
   --     begin
   --        Int64_Pending_Auto_Req_Matrix.Insert (Container => This.Pending_Auto_Req,
   --                                              Key       => ReqID,
   --                                              New_Item  => Int64_Sets.Empty_Set);
   --  
   --        if Is_Empty (Entity_List) then
   --  
   --  
   --           declare
   --  
   --              State_Cursor :  Int64_Entity_State_Maps.Cursor :=  Int64_Entity_State_Maps.First (Container => This.Entity_State);
   --           begin
   --  
   --  
   --              while Int64_Entity_State_Maps.Has_Element (Container => This.Entity_State,
   --                                                         Position  => State_Cursor) loop
   --                 Append (Entity_List,
   --                         Get_ID (Int64_Entity_State_Maps.Element (Container => This.Entity_State,
   --                                                                  Position  => State_Cursor).Content));
   --  
   --                 Int64_Entity_State_Maps.Next (Container => This.Entity_State,
   --                                               Position  => State_Cursor);
   --              end loop;
   --  
   --  
   --           end;
   --  
   --  
   --        end if;
   --  
   --  
   --        for Index_EntityList in First_Index (Entity_List) .. Last_Index (Entity_List)loop
   --  
   --  
   --           declare
   --              Vehicle_ID : constant Int64 := Element (Entity_List , Index_EntityList);
   --              Vehicles : My_EntityState;
   --              Contains_Vehicles : constant Boolean := Int64_Entity_State_Maps.Contains (Container => This.Entity_State,
   --                                                                                        Key  => Vehicle_ID);
   --              Start_Heading_DEG : Real32 := 0.0;
   --  
   --              Start_Location : My_Location3D_Any;
   --  
   --              Is_Foud_Planning_State : Boolean := False;
   --  
   --  
   --              use My_Task_Option_Vects;
   --  
   --              My_Task_Option_Vects_Commun_Max_Capacity : constant := 200; -- arbitrary
   --  
   --              subtype My_Task_Option_Vect is My_Task_Option_Vects.Vector
   --                (My_Task_Option_Vects_Commun_Max_Capacity);
   --  
   --              Task_Option_List : My_Task_Option_Vect;
   --  
   --              use Int64_Task_Plan_Options_Maps;
   --              use all type Vect_My_PlanningState;
   --           begin
   --  
   --  
   --  
   --              for Index_Planning_State in First_Index ( Get_PlanningStates (Areq)) .. Last_Index ( Get_PlanningStates (Areq)) loop
   --                 declare
   --                    Planning_State : constant My_PlanningState := Element ( Get_PlanningStates (Areq), Index_Planning_State);
   --                 begin
   --  
   --                    if Get_EntityId (Planning_State) = Vehicle_ID then
   --                       Start_Location    := Get_PlanningPosition (Planning_State); 
   --                       Start_Heading_DEG := Get_PlanningHeading  (Planning_State);
   --                       Is_Foud_Planning_State := True;
   --                       exit;
   --                    end if;
   --                 end;
   --              end loop;
   --  
   --  
   --              if Is_Foud_Planning_State and Contains_Vehicles then
   --                 Vehicles := Int64_Entity_State_Maps.Element (Container => This.Entity_State,
   --                                                              Key       =>  Vehicle_ID).Content;
   --  
   --                 for  Index_TaskList in First_Index (Get_TaskList_From_OriginalRequest (Areq)) .. Last_Index (Get_TaskList_From_OriginalRequest (Areq) ) loop
   --                    declare
   --                       Task_ID : constant Int64 := Element (Get_TaskList_From_OriginalRequest (Areq) , Index_TaskList);
   --                    begin
   --  
   --  
   --                       if Contains (This.Task_Plan_Options,
   --                                    Task_ID) then
   --                          declare
   --                             Task_Plan_Options : constant My_TaskPlanOptions := Element (This.Task_Plan_Options,
   --                                                                                         Task_ID).Content;
   --                             Tasks_List : constant Vect_My_TaskOption := Get_Options (Task_Plan_Options);
   --                             use Vect_My_TaskOptions;
   --                          begin
   --  
   --                             for Index_Task in First_Index (Tasks_List) .. Last_Index (Tasks_List) loop
   --                                declare
   --                                   Option : constant My_TaskOption := Element (Container => Tasks_List,
   --                                                                               Index     => Index_Task);
   --                                begin
   --                                   if  Is_Empty (Get_EligibleEntities (Option))
   --                                     and Contains (Container => Get_EligibleEntities (Option),
   --                                                   Item => Vehicle_ID) then
   --                                      My_Task_Option_Vects.Append (Container => Task_Option_List,
   --                                                                   New_Item  => Option); -- TODO clone here
   --                                   end if;
   --                                end;
   --  
   --                             end loop;
   --                          end;
   --  
   --                       end if;
   --                    end;
   --                 end loop;
   --  
   --                 --    // create a new route plan request
   --                 declare
   --  
   --                    Plan_Request : My_RoutePlanRequest;
   --                    List_Pending_Request : Int64_Set := Int64_Pending_Auto_Req_Matrix.Element (Container => This.Pending_Auto_Req,
   --                                                                                               Key       => ReqID);
   --                 begin
   --  
   --                    Set_AssociatedTaskID (Plan_Request,  0);
   --                    Set_IsCostOnlyRequest (Plan_Request, False);
   --                    Set_OperatingRegion   (Plan_Request, Get_OperatingRegion_From_OriginalRequest (Areq));
   --                    Set_VehicleID (Plan_Request, Vehicle_ID);
   --                    --  //planRequest->setRouteID (m_planrequestId);
   --                    --  //m_planrequestId++;
   --  
   --                    if not Is_Foud_Planning_State then
   --  
   --                       Start_Location := Get_Location (Vehicles);
   --                       Start_Heading_DEG := Get_Heading (Vehicles);
   --  
   --                    end if;
   --  
   --                  
   --  
   --  
   --  
   --                    for Id_Opt_1  in First_Index (Task_Option_List) .. Last_Index (Task_Option_List) loop
   --                       
   --                       
   --                       --  // find routes from initial conditions
   --                       declare
   --                          Option_1 : constant My_TaskOption := Element (Task_Option_List,Id_Opt_1);
   --                       begin
   --                          declare 
   --                             --  // build map from request to full task/option information
   --                             Task_Option_Pair : constant AggregatorTaskOptionPair := AggregatorTaskOptionPair'(VehicleId      => Vehicle_ID,
   --                                                                                                               PrevTaskId     => 0,
   --                                                                                                               PrevTaskOption => 0,
   --                                                                                                               TaskId         => Get_TaskID   (Option_1),
   --                                                                                                               TaskOption     => Get_OptionID (Option_1));
   --                             Route_Constraints : My_RouteConstraints;
   --                             --:= UxAS.Messages.Route.RouteConstraints.Spark_Boundary.Wrap ( RouteConstraints );
   --                             use Int64_Aggregator_Task_Option_Pair_Maps;
   --                          begin
   --                             
   --  
   --  
   --                       
   --                             Include (Container => This.Route_Task_Pairing,
   --                                      Key       => This.Route_Id,
   --                                      New_Item  => Task_Option_Pair);
   --  
   --                             Set_StartLocation (Route_Constraints, Start_Location);
   --                             Set_StartHeading  (Route_Constraints, Start_Heading_DEG);
   --                             Set_EndLocation   (Route_Constraints, Get_StartLocation (Option_1));
   --                             Set_EndHeading    (Route_Constraints, Get_StartHeading  (Option_1));
   --                             Set_RouteID       (Route_Constraints, This.Route_Id);
   --                             Append_RouteRequests (This          => Plan_Request,
   --                                                   RouteRequests => Route_Constraints);
   --  
   --                          end;
   --  
   --                          Int64_Sets.Include (Container => List_Pending_Request,
   --                                              New_Item  => This.Route_Id);
   --  
   --                          This.Route_Id := This.Route_Id + 1;
   --                          
   --                       
   --                          -- combination routes
   --                          for Id_Opt_2  in First_Index (Task_Option_List) .. Last_Index (Task_Option_List) loop
   --  
   --                             if not (Id_Opt_1 = Id_Opt_2) then
   --                                declare
   --                                   Option_2 : constant My_TaskOption := Element (Task_Option_List,Id_Opt_2);
   --                                
   --                                   -- // build map from request to full task/option information
   --                          
   --                                   Task_Option_Pair : constant AggregatorTaskOptionPair := AggregatorTaskOptionPair'(VehicleId      => Vehicle_ID,
   --                                                                                                                     PrevTaskId     => Get_OptionID (Option_1),
   --                                                                                                                     PrevTaskOption => Get_TaskID   (Option_1),
   --                                                                                                                     TaskId         => Get_OptionID (Option_2),
   --                                                                                                                     TaskOption     => Get_TaskID   (Option_2));
   --                                   Route_Constraints : My_RouteConstraints;
   --                                
   --                                begin
   --                                
   --                                   Int64_Aggregator_Task_Option_Pair_Maps.Insert (Container => This.Route_Task_Pairing,
   --                                                                                  Key       => This.Route_Id,
   --                                                                                  New_Item  => Task_Option_Pair);
   --                                
   --                                   Set_StartLocation (Route_Constraints, Get_EndLocation (Option_1));
   --                                   Set_StartHeading  (Route_Constraints, Get_EndHeading  (Option_1));
   --                                   Set_EndLocation   (Route_Constraints, Get_StartLocation (Option_2));
   --                                   Set_EndHeading    (Route_Constraints, Get_StartHeading  (Option_2));
   --                                   Set_RouteID       (Route_Constraints, This.Route_Id);
   --                                
   --                                   Append_RouteRequests (Plan_Request, Route_Constraints);
   --                              
   --                                
   --                           
   --                                end;  
   --                                Int64_Sets.Include (Container => List_Pending_Request,
   --                                                    New_Item  => This.Route_Id);
   --                                This.Route_Id := THis.Route_Id + 1;
   --                             end if;
   --                          end loop;
   --                       end;
   --                    end loop;
   --                    
   --                    Int64_Pending_Auto_Req_Matrix.Replace (Container => This.Pending_Auto_Req,
   --                                                           Key       => ReqID,
   --                                                           New_Item  => List_Pending_Request);
   --                          
   --                    
   --                    if Int64_Sets.Contains (Container => This.Ground_Vehicles,
   --                                            Item      => Vehicle_ID) then
   --                       My_Plan_Request_Vects.Append (Container => Send_Ground_Plan_Request,
   --                                                     New_Item  => Plan_Request);
   --                    else
   --                       My_Plan_Request_Vects.Append (Container => Send_Air_Plan_Request,
   --                                                     New_Item  => Plan_Request);
   --                    end if;
   --                 end;
   --                         
   --              end if;
   --                 
   --           end;
   --              
   --        end loop;
   --           
   --           
   --        for Id_Req in First_Index (Send_Air_Plan_Request) .. Last_Index (Send_Air_Plan_Request) loop
   --           My_Send_Shared_LMCP_Object_Limited_Cast_Message (This,
   --                                                            AIrcraftPathPlanner,
   --                                                            Element (Send_Air_Plan_Request,Id_Req));
   --        end loop;
   --        
   --        for Id_Req in First_Index (Send_Ground_Plan_Request) .. Last_Index (Send_Ground_Plan_Request) loop
   --           My_Send_Shared_LMCP_Object_Limited_Cast_Message (This,
   --                                                            GroundPathPlanner,
   --                                                            Element (Send_Ground_Plan_Request,Id_Req));
   --        end loop;
   --           
   --        if This.Fast_Plan then
   --           Check_All_Route_Plans (This);
   --           
   --        end if;
   --        
   --     end Build_Matrix_Requests;
   --        
   --  
   --     ------------------------
   --     -- Send_Route_Reponse --
   --     ------------------------
   --     
   --        
   --     -- void SendRouteResponse (int64_t);
   --     procedure Send_Route_Reponse ( This : in out Route_Aggregator_Service;
   --                                    RouteKey : Int64)
   --     is 
   --        procedure My_Send_LMCP_Object_Broadcast_Message
   --          (This :in out Route_Aggregator_Service ;
   --           Request : My_RouteResponse);
   --        
   --        procedure My_Send_LMCP_Object_Broadcast_Message
   --          (This :in out Route_Aggregator_Service ;
   --           Request : My_RouteResponse) 
   --          with
   --            SPARK_Mode => Off
   --          
   --        is
   --           Request_Acc : constant RouteResponse_Acc := new RouteResponse;
   --        begin
   --           Request_Acc.all := Unwrap (Request);
   --           
   --           This.Send_LMCP_Object_Broadcast_Message (Object_Any(Request_Acc)); 
   --        end My_Send_LMCP_Object_Broadcast_Message;
   --        
   --        
   --        Response  : My_RouteResponse;
   --        Exepcted_Plan_Response_IDs : constant Int64_Set := Int64_Pending_Route_Matrix.Element (This.Pending_Route,
   --                                                                                               RouteKey);
   --        
   --        
   --     begin
   --                
   --        --  response->setResponseID (routeKey);
   --        Set_ResponseID (Response, RouteKey);
   --              
   --        --  for (auto& rId : m_pendingRoute[routeKey])
   --        for Plan_Reponse_Id of Exepcted_Plan_Response_IDs loop
   --                 
   --           --  auto plan = m_routePlanResponses.find (rId);
   --           --  if (plan != m_routePlanResponses.end ())
   --           
   --           -- verify by contrustion / call
   --           -- if Int64_Route_Plan_Responses_Maps.Contains (This.Route_Plan_Responses,
   --           --                                             Plan_Reponse_Id) then     
   --           
   --           declare
   --              Plan : constant My_RoutePlanResponse := Int64_Route_Plan_Responses_Maps.Element (This.Route_Plan_Responses,
   --                                                                                               Plan_Reponse_Id).Content;
   --              use Int64_Vects;
   --              
   --              Route_Responses_ID : constant Int64_Vect:= Get_ID_From_RouteResponses (Plan);
   --                          
   --           begin
   --                          
   --                 
   --              Add_Route (Response, Plan);    -- clone here   
   --                       
   --                       
   --              --  // delete all individual routes from storage
   --              --  for (auto& i : plan->second->getRouteResponses ())
   --                 
   --              for Index_Route_ID in First_Index (Route_Responses_ID) .. Last_Index (Route_Responses_ID)loop
   --                            
   --                 --  M_RoutePlans.Erase (I->GetRouteID ());
   --                 Int64_Pair_Int64_Route_Plan_Maps.Delete (This.Route_Plan,
   --                                                          Element (Container => Route_Responses_ID,
   --                                                                   Index     => Index_Route_ID));
   --              end loop;
   --                       
   --              --   m_routePlanResponses.erase (plan);   
   --              Int64_Route_Plan_Responses_Maps.Delete (This.Route_Plan_Responses,
   --                                                      Plan_Reponse_Id);
   --           end;
   --           -- end if;
   --        end loop;
   --                 
   --        --  sendSharedLmcpObjectBroadcastMessage (pResponse);
   --        My_Send_LMCP_Object_Broadcast_Message  (This,
   --                                                Response);
   --             
   --                 
   --     end Send_Route_Reponse;
   --           
   --        
   --     -----------------
   --     -- Send_Matrix --
   --     -----------------
   --             
   --     procedure Send_Matrix ( This : in out Route_Aggregator_Service;
   --                             AutoKey : Int64)
   --     is
   --     
   --        procedure My_Send_Shared_LMCP_Object_Broadcast_Message
   --          (This : in out Route_Aggregator_Service;
   --           Matrix : My_AssignmentCostMatrix);
   --        procedure My_Send_LMCP_Object_Broadcast_Message
   --          ( This : in out Route_Aggregator_Service;
   --            Service_Status : My_ServiceStatus);
   --           
   --        procedure My_Send_Shared_LMCP_Object_Broadcast_Message
   --          (This : in out Route_Aggregator_Service;
   --           Matrix : My_AssignmentCostMatrix) with 
   --          SPARK_Mode => Off
   --        is 
   --           Matrix_Acc : constant AssignmentCostMatrix_Acc := new AssignmentCostMatrix;
   --              
   --        begin
   --           Matrix_Acc.all := Unwrap (Matrix);
   --           This.Send_Shared_LMCP_Object_Broadcast_Message (Object_Any(Matrix_Acc));
   --        end My_Send_Shared_LMCP_Object_Broadcast_Message;
   --           
   --              
   --        procedure My_Send_LMCP_Object_Broadcast_Message
   --          ( This : in out Route_Aggregator_Service;
   --            Service_Status : My_ServiceStatus) with 
   --          SPARK_Mode => Off
   --        is 
   --           Service_Status_Acc : constant ServiceStatus_Acc := new ServiceStatus;
   --        begin
   --           Service_Status_Acc.all := Unwrap (Service_Status);
   --           This.Send_Shared_LMCP_Object_Broadcast_Message (Object_Any(Service_Status_Acc));
   --        end My_Send_LMCP_Object_Broadcast_Message;
   --            
   --            
   --        --   auto matrix = std::shared_ptr<uxas::messages::task::AssignmentCostMatrix>(new uxas::messages::task::AssignmentCostMatrix);
   --        Matrix :  My_AssignmentCostMatrix;
   --              
   --        --   auto& areq = m_uniqueAutomationRequests[autoKey];
   --        Areq   : constant My_UniqueAutomationRequest := 
   --          Int64_Unique_Automation_Request_Maps.Element (Container => This.Unique_Automation_Request,
   --                                                        Key       => AutoKey).Content;
   --        Route_Not_Found : Unbounded_String := To_Unbounded_String ("");
   --                       
   --        Service_Status  : My_ServiceStatus;
   --           
   --     begin
   --          
   --        Set_CorrespondingAutomationRequestID ( Matrix , GetRequestID (Areq));
   --        Set_OperatingRegion ( Matrix , Get_OperatingRegion_From_OriginalRequest ( Areq ) );
   --        Set_TaskLevelRelationship ( Matrix , Get_TaskRelationship_From_OriginalRequest ( Areq )) ;
   --        Set_TaskList ( Matrix , Get_TaskList_From_OriginalRequest (Areq));
   --           
   --           
   --           
   --           
   --           
   --           
   --        --   for (auto& rId : m_pendingAutoReq[autoKey])
   --        for R_Id of Int64_Pending_Auto_Req_Matrix.Element (Container => This.Pending_Auto_Req,
   --                                                           Key       => AutoKey) loop 
   --                 
   --           --  auto plan = m_routePlans.find (rId);
   --           --  if (plan != m_routePlans.end ())  -- Valid by construction
   --           declare
   --              --  auto taskpair = m_routeTaskPairing.find (rId);
   --              Plan : constant Pair_Int64_Route_Plan := Int64_Pair_Int64_Route_Plan_Maps.Element (This.Route_Plan,
   --                                                                                                 R_ID);
   --           begin
   --                      
   --              -- if (taskpair != m_routeTaskPairing.end ())
   --              if Int64_Aggregator_Task_Option_Pair_Maps.Contains (Container => This.Route_Task_Pairing,
   --                                                                  Key       => R_ID)
   --              then
   --                 declare
   --                    Task_Pair : constant AggregatorTaskOptionPair := Int64_Aggregator_Task_Option_Pair_Maps.Element ( This.Route_Task_Pairing,
   --                                                                                                                      R_Id);
   --                                  
   --                    -- auto toc = new uxas::messages::task::TaskOptionCost;                                                                                      
   --                    Task_Option_Cost : My_TaskOptionCost;
   --                 begin
   --                             
   --                    -- if (plan->second.second->getRouteCost () < 0)
   --                    if (Get_RouteCost (Plan.Returned_Route_Plan) < 0)
   --                    then
   --                       Route_Not_Found := To_Unbounded_String ("V[" & Task_Pair.VehicleId'Image & "](" & Task_Pair.PrevTaskId'Image  &  ","
   --                                                               & Task_Pair.PrevTaskOption'Image  & ")-(" & Task_Pair.TaskId'Image  & "," & Task_Pair.TaskOption'Image  & ")") ;
   --                    end if;
   --                                      
   --                                      
   --                    Set_DestinationTaskID (Task_Option_Cost, Task_Pair.TaskId);
   --                    Set_IntialTaskOption  (Task_Option_Cost, Task_Pair.PrevTaskOption);
   --                    Set_DestinationTaskOption (Task_Option_Cost, Task_Pair.TaskOption);
   --                    Set_IntialTaskID (Task_Option_Cost, Task_Pair.PrevTaskId);
   --                    Set_TimeToGo  (Task_Option_Cost, Get_RouteCost ( Plan.Returned_Route_Plan));
   --                    Set_VehicleID (Task_Option_Cost, Task_Pair.VehicleId);
   --                            
   --                    --  matrix->getCostMatrix ().push_back(toc);
   --                    Add_TaskOptionCost_To_CostMatrix (Matrix, Task_Option_Cost);
   --                             
   --                    -- m_routeTaskPairing.erase (taskpair); 
   --                    Int64_Aggregator_Task_Option_Pair_Maps.Delete (This.Route_Task_Pairing,
   --                                                                   R_Id);
   --                 end;
   --              end if;
   --              --  // Clear out Memory
   --              --  M_RoutePlanResponses.Erase (Plan->Second.First);
   --              --  M_RoutePlans.Erase (Plan);
   --                                
   --              Int64_Route_Plan_Responses_Maps.Delete (This.Route_Plan_Responses,
   --                                                      Plan.Reponse_ID);
   --              Int64_Pair_Int64_Route_Plan_Maps.Delete (This.Route_Plan,
   --                                                       R_ID);
   --           end;
   --        end loop;
   --              
   --        --  // Send The Total Cost Matrix
   --        --  Std::Shared_Ptr<Avtas::Lmcp::Object> PResponse = Std::Static_Pointer_Cast<Avtas::Lmcp::Object>(Matrix);
   --        --  SendSharedLmcpObjectBroadcastMessage (PResponse);
   --        My_Send_Shared_LMCP_Object_Broadcast_Message (This,
   --                                                      Matrix);
   --          
   --         
   --        --  // clear out old options
   --        --  M_TaskOptions.Clear();
   --        Int64_Task_Plan_Options_Maps.Clear(This.Task_Plan_Options);
   --                       
   --              
   --              
   --        Set_StatusType (Service_Status, Afrl.Cmasi.Enumerations.Information);
   --        --  if (!routesNotFound.str().empty())
   --        if Length(Route_Not_Found) > 0 then
   --                          
   --           Add_KeyPair (This          => Service_Status,
   --                        KeyPair_Key   => To_Unbounded_String ("RoutesNotFound - [VehicleId](StartTaskId,StartOptionId)-(EndTaskId,EndOptionId)"),
   --                        KeyPair_Value => Route_Not_Found);
   --                 
   --                
   --           Put (To_String ("RoutesNotFound - [VehicleId](StartTaskId,StartOptionId)-(EndTaskId,EndOptionId) :: " & Route_Not_Found));
   --                       
   --        else
   --              
   --           Add_KeyPair (This          => Service_Status,
   --                        KeyPair_Key   => To_Unbounded_String ("AssignmentMatrix - full"));
   --                 
   --        end if;
   --              
   --        --  sendSharedLmcpObjectBroadcastMessage (serviceStatus);
   --        My_Send_LMCP_Object_Broadcast_Message (This,Service_Status);
   --              
   --              
   --     end Send_Matrix;
   --        
   --     --------------------------
   --     -- Check_All_Route_Plans --
   --     --------------------------
   --        
   --           
   --     procedure Check_All_Route_Plans (This : in out Route_Aggregator_Service)
   --     is
   --       
   --           
   --           
   --        -- TODO : Put Send_matrix here
   --        
   --        -- TODO : Put Send_Route_Response
   --     
   --        
   --        
   --        C : Int64_Pending_Route_Matrix.Cursor :=
   --          Int64_Pending_Route_Matrix.First (Container => This.Pending_Route);
   --        
   --        I : Int64_Pending_Auto_Req_Matrix.Cursor :=
   --          Int64_Pending_Auto_Req_Matrix.First (Container => THis.Pending_Auto_Req);
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
   --        -- while (i != m_pendingRoute.end ())
   --        
   --        while Int64_Pending_Route_Matrix.Has_Element (Container => This.Pending_Route ,
   --                                                      Position  => C)
   --        loop
   --           declare
   --                 
   --        
   --              -- i->first ()
   --              Route_Id : constant Int64 :=
   --                Int64_Pending_Route_Matrix.Key(Container => This.Pending_Route,
   --                                               Position  => C);
   --        
   --              -- i->second ()
   --              Liste_RouteRequest_ID : constant  Int64_Set :=
   --                Int64_Pending_Route_Matrix.Element (Container => THis.Pending_Route,
   --                                                    Position  => C);
   --                
   --              -- bool isFulfilled = true;
   --              Is_Fulfilled : constant Boolean := (for all Id_Request of Liste_RouteRequest_ID => 
   --                                                    Int64_Route_Plan_Responses_Maps.Contains (Container => This.Route_Plan_Responses,
   --                                                                                              Key       => Id_Request));
   --           begin
   --        
   --        
   --              Int64_Pending_Route_Matrix.Next (Container => THis.Pending_Route,
   --                                               Position  => C);
   --              if (Is_Fulfilled) then
   --      
   --                 Send_Route_Reponse (This     => This,
   --                                     RouteKey => Route_Id);
   --                    
   --                 Int64_Pending_Route_Matrix.Delete (Container => This.Pending_Route,
   --                                                    Key       => Route_Id);
   --              end if;
   --           end;
   --        end loop;
   --        
   --        
   --        -- // check pending automation requests
   --        -- auto k = m_pendingAutoReq.begin();
   --        -- while (k != m_pendingAutoReq.end ())
   --        while Int64_Pending_Auto_Req_Matrix.Has_Element (Container => THis.Pending_Auto_Req,
   --                                                         Position  => I)
   --        loop
   --           declare
   --        
   --              -- k->first ()
   --              Req_Id : constant Int64 := Int64_Pending_Auto_Req_Matrix.Key(Container => THis.Pending_Auto_Req,
   --                                                                           Position  => I);
   --        
   --              -- k->second ()
   --              All_Response_ID : constant Int64_Set := Int64_Pending_Auto_Req_Matrix.Element (Container => This.Pending_Auto_Req,
   --                                                                                             Position  => I);
   --                 
   --              Is_Fulfilled : constant Boolean := (for all Response_ID of All_Response_ID =>
   --                                                    Int64_Pair_Int64_Route_Plan_Maps.Contains (Container => THis.Route_Plan,
   --                                                                                               Key       => Response_ID));
   --           begin
   --                
   --        
   --              Int64_Pending_Auto_Req_Matrix.Next (Container => THis.Pending_Auto_Req,
   --                                                  Position  => I);
   --        
   --     
   --              if Is_Fulfilled then
   --        
   --                 -- SendMatrix (k->first);
   --                 Send_Matrix (This,Req_Id);
   --        
   --                 -- // finished with this automation request, discard
   --                 -- m_uniqueAutomationRequests.erase (k->first);
   --                 
   --                
   --                 Int64_Unique_Automation_Request_Maps.Delete (Container => This.Unique_Automation_Request,
   --                                                              Key       => Req_Id);
   --                 
   --                 -- k = m_pendingAutoReq.erase (k);
   --                 Int64_Pending_Auto_Req_Matrix.Delete (Container => This.Pending_Auto_Req,
   --                                                       Key       => Req_Id);
   --                 
   --              end if;
   --           end;
   --        
   --        end loop;
   --           
   --          
   --        
   --     end Check_All_Route_Plans;
   --        
   --     ------------------------------------
   --     -- Check_All_Task_Option_Received --
   --     ------------------------------------
   --           
   --     procedure Check_All_Task_Option_Received (This : in out Route_Aggregator_Service)
   --     is
   --        
   --        -- TODO : Put Build_Matrix_Requests here
   --        
   --        C : Int64_Unique_Automation_Request_Maps.Cursor := Int64_Unique_Automation_Request_Maps.First (Container => THis.Unique_Automation_Request);
   --            
   --              
   --     begin
   --        while Int64_Unique_Automation_Request_Maps.Has_Element (Container => This.Unique_Automation_Request,
   --                                                                Position  => C) loop
   --        
   --           declare
   --        
   --              -- // check that to see if all options from all tasks have been received for this request
   --              -- bool isAllReceived{true};
   --              Is_All_Received : Boolean := True;
   --        
   --              -- areqIter->second
   --              Request : constant My_UniqueAutomationRequest := Int64_Unique_Automation_Request_Maps.Element (Container => This.Unique_Automation_Request,
   --        
   --                                                                                                             Position  => C).Content;
   --        
   --              -- areqIter->first
   --              Index_Request : constant Int64 := Int64_Unique_Automation_Request_Maps.Key(Container => This.Unique_Automation_Request,
   --                                                                                         Position  => C);
   --              use Int64_Vects;
   --           begin
   --        
   --              -- for (size_t t = 0; t < areqIter->second->getOriginalRequest ()->getTaskList ().size (); t++)
   --              for T in First_Index (Get_TaskList_From_OriginalRequest (Request)) .. Last_Index (Get_TaskList_From_OriginalRequest (Request)) loop
   --        
   --        
   --                 declare
   --                    -- int64_t taskId = areqIter->second->getOriginalRequest ()->getTaskList ().at (t);
   --                    Task_ID : constant Int64 := Element (Container => Get_TaskList_From_OriginalRequest (Request) ,
   --                                                         Index     => T);
   --                 begin
   --        
   --                    -- if (m_taskOptions.find (taskId) == m_taskOptions.end ())
   --                    if Int64_Task_Plan_Options_Maps.Contains (Container => This.Task_Plan_Options,
   --                                                              Key       => Task_ID )
   --                    then
   --                       Is_All_Received := False;
   --                       exit;
   --                    end if;
   --                 end;
   --        
   --        
   --              end loop;
   --        
   --              --  if (isAllReceived)
   --              if Is_All_Received then
   --        
   --        
   --                 -- BuildMatrixRequests (areqIter->first, areqIter->second);
   --                 Build_Matrix_Requests (This  => This,
   --                                        ReqID => Index_Request,
   --                                        Areq  => Request);
   --              end if;
   --           end;
   --        
   --           --  areqIter++;
   --           Int64_Unique_Automation_Request_Maps.Next (Container => This.Unique_Automation_Request,
   --                                                      Position  => C);
   --        end loop;
   --     end Check_All_Task_Option_Received;
   --        
      
   --------------------
   -- Euclidean_Plan --
   --------------------
            
   -- void EuclideanPlan(std::shared_ptr<uxas::messages::route::RoutePlanRequest>);
   procedure Euclidean_Plan(This             : in out Route_Aggregator_Service;
                            Route_Plan_Request : in My_RoutePlanRequest)
                    
   is
      -- uxas::common::utilities::CUnitConversions flatEarth;
      -- int64_t regionId = request->getOperatingRegion();
      -- int64_t vehicleId = request->getVehicleID ();
      -- int64_t taskId = request->getAssociatedTaskID ();
      Region_ID   : constant Int64 := Get_OperatingRegion (Route_Plan_Request);
      Vehicles_ID : constant Int64 := Get_VehicleID (Route_Plan_Request);
      Task_ID     : constant Int64 := Get_AssociatedTaskID (Route_Plan_Request);
      Request_ID  : constant Int64 := Get_RequestID (Route_Plan_Request);
      -- double speed = 1.0; // default if no speed available
      Speed  : Long_Float := 1.0;
                  
      --  auto response = std::shared_ptr<uxas::messages::route::RoutePlanResponse>(new uxas::messages::route::RoutePlanResponse);
      Response : My_RoutePlanResponse;
      use Vect_My_RouteConstraints_P;
   begin
      --  if (m_entityConfigurations.find (vehicleId) != m_entityConfigurations.end ())
      if Int64_Entity_Configuration_Maps.Contains (Container => This.Entity_Configuration,
                                                   Key       => Vehicles_ID)
      then
                  
                  
         --   double speed = m_entityConfigurations[vehicleId]->getNominalSpeed ();
         Speed := Long_Float (Get_NominalSpeed (Int64_Entity_Configuration_Maps.Element (Container => This.Entity_Configuration,
                                                                                         Key       => Vehicles_ID).Content));
                  
         -- if (speed < 1e-2)
         if (Speed < 0.02) then
            --  speed = 1.0; // default to 1 if too small for division
            Speed := 1.0;
         end if;
      end if;
      pragma Assert (Speed > 0.02);
                  
      Set_AssociatedTaskID (Response, Task_ID);
      Set_OperatingRegion  (Response, Region_ID);
      Set_VehicleID  (Response, Vehicles_ID);
      Set_ResponseID (Response, Request_ID);
      pragma Assert (Get_ResponseID (Response) = Request_ID);
      pragma Assert (Check_Route_Plan_Response (This.Route_Plan_Responses));
      pragma Assert (All_Requests_Valid (This));
      -- move it here for Check_Route_Plan
      -- m_routePlanResponses[response->getResponseID ()] = response;
      declare
         RoutePlanResponses_Holder : constant Route_Plan_Responses_Holder := Route_Plan_Responses_Holder'(Content => Response);
         This_Route_Plan_Responses_Old : constant Route_Plan_Responses_Map:= This.Route_Plan_Responses with Ghost;
      begin
         
         pragma Assert (if All_Requests_Valid (This) then
                           Check_Route_Plan (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses));
         pragma Assert (for all C in This.Route_Plan 
                        => Get_RouteID ( Element (This.Route_Plan, C).Returned_Route_Plan) = Key ( THis.Route_Plan, C)
                        and Contains (This.Pending_Route,        Element (This.Route_Plan, C).Reponse_ID)
                        and Contains (This.Route_Plan_Responses, Element (This.Route_Plan, C).Reponse_ID));
         pragma Assert (for all C in This.Route_Plan_Responses 
                        =>  Check_Route_Plan_Response_Sub (Element (This.Route_Plan_Responses, C).Content, Key ( This.Route_Plan_Responses, C)));
         pragma Assert (for all Key in Int64 
                        => (if Contains (This.Route_Plan_Responses, Key) then
                               Int64_Route_Plan_Responses_Maps.Key (This.Route_Plan_Responses, Find (This.Route_Plan_Responses, Key)) = Key
                            and Get_ResponseID (Element  (This.Route_Plan_Responses    , Find (This.Route_Plan_Responses, Key)).Content) =  Key
                            and Check_Route_Plan_Response_Sub (Element (This.Route_Plan_Responses, Find (This.Route_Plan_Responses, Key)).Content,  Key )));

      
         Int64_Route_Plan_Responses_Maps.Insert
           (Container => This.Route_Plan_Responses,
            Key       => Get_ResponseID (RoutePlanResponses_Holder.Content),
            New_Item  => RoutePlanResponses_Holder);
         pragma Assert (Contains (This.Route_Plan_Responses, Get_ResponseID (RoutePlanResponses_Holder.Content))
                        and then Check_Route_Plan_Response_Sub (Route_Plan_Response => Element ( This.Route_Plan_Responses, Get_ResponseID (RoutePlanResponses_Holder.Content)).Content,
                                                                Key                 =>  Get_ResponseID (RoutePlanResponses_Holder.Content)));
                       
         Lemma_Ceck_Route_Plan_Reference_Insert (This.Route_Plan,
                                                 This.Pending_Route, This.Pending_Route,
                                                 This_Route_Plan_Responses_Old, This.Route_Plan_Responses);
         pragma Assert (Check_Route_Plan (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses));
         
         pragma Assert (if  Check_Route_Plan_Response   (This.Route_Plan_Responses) 
                        then All_Requests_Valid (This));
         pragma Assert ( Contains (This.Route_Plan_Responses, Get_ResponseID (Response)));
         pragma Assert ( Model (This_Route_Plan_Responses_Old) <= Model (This.Route_Plan_Responses));
         pragma Assert (Int64_Route_Plan_Responses_Maps.Formal_Model.M.Keys_Included_Except ( Model (This.Route_Plan_Responses),
                        Model (This_Route_Plan_Responses_Old),
                        Get_ResponseID (Response)));
         pragma Assert (for all Key in Int64
                        => (if Contains (This_Route_Plan_Responses_Old, Key) then
                               Contains (This.Route_Plan_Responses,     Key)));
         pragma Assert (for all C in This.Route_Plan
                        => Contains (This_Route_Plan_Responses_Old, Element (THis.Route_Plan, C).Reponse_ID)
                        and Contains (This.Route_Plan_Responses,     Element (THis.Route_Plan, C).Reponse_ID));
               
       
         pragma Assert (for all Key of Model (This_Route_Plan_Responses_Old)
                        =>  (Contains (This.Route_Plan_Responses, Key)
                             and Contains (This_Route_Plan_Responses_Old, Key)
                             and Int64_Route_Plan_Responses_Maps.Formal_Model.M.Has_Key ( Model (This.Route_Plan_Responses), Key))
                        and then
                          (Int64_Route_Plan_Responses_Maps.Formal_Model.M.Get (Model (This.Route_Plan_Responses), Key) = 
                             Int64_Route_Plan_Responses_Maps.Formal_Model.M.Get (Model (This_Route_Plan_Responses_Old), Key)
                           and (if Int64_Route_Plan_Responses_Maps.Formal_Model.M.Get (Model (This.Route_Plan_Responses), Key) =
                                 Int64_Route_Plan_Responses_Maps.Formal_Model.M.Get (Model (This_Route_Plan_Responses_Old), Key) then
                                Element (This.Route_Plan_Responses,  Key) = Element (This_Route_Plan_Responses_Old,  Key))
                           and (if  Element (This.Route_Plan_Responses,  Key) = Element (This_Route_Plan_Responses_Old,  Key) then
                                Element (This.Route_Plan_Responses,  Key).Content = Element (This_Route_Plan_Responses_Old,  Key).Content)
                           and (if Element (This.Route_Plan_Responses,  Key).Content = Element (This_Route_Plan_Responses_Old,  Key).Content then
                                Get_ResponseID (Element (This.Route_Plan_Responses,  Key).Content) = Get_ResponseID (Element (This_Route_Plan_Responses_Old,  Key).Content))
                    
                           and (if   Get_ResponseID (Element (This.Route_Plan_Responses,  Key).Content) = Get_ResponseID (Element (This_Route_Plan_Responses_Old,  Key).Content)
                             and Get_ResponseID (Element  (This_Route_Plan_Responses_Old, Key).Content) =  Key then
                                Get_ResponseID (Element  (This.Route_Plan_Responses    , Key).Content) =  Key)
                           and (if   Get_ResponseID (Element  (This.Route_Plan_Responses    , Key).Content) =  Key then
                                  Check_Route_Plan_Response_Sub (Element  (This.Route_Plan_Responses, Key).Content , Key))
                           and Check_Route_Plan_Response_Sub (Element (This_Route_Plan_Responses_Old, Key).Content, Key )));
         pragma Assert (for all C in This.Route_Plan_Responses
                        => (if  Key (This.Route_Plan_Responses, C) =  Get_ResponseID (Response)
                            then
                               Check_Route_Plan_Response_Sub (Element  (This.Route_Plan_Responses, C).Content, Key (This.Route_Plan_Responses, C))
                            else
                               Check_Route_Plan_Response_Sub (Element  (This.Route_Plan_Responses, C).Content, Key (This.Route_Plan_Responses, C))));
        
         pragma Assert (for all C in This.Route_Plan_Responses
                        =>  Check_Route_Plan_Response_Sub (Element  (This.Route_Plan_Responses, C).Content, Key (This.Route_Plan_Responses, C)));
         pragma Assert (if (for all C in This.Route_Plan_Responses
                        => Check_Route_Plan_Response_Sub (Element  (This.Route_Plan_Responses, C).Content, Key (This.Route_Plan_Responses, C)))
                        then Check_Route_Plan_Response     (This.Route_Plan_Responses));
         pragma Assert (if Check_Route_Plan_Response     (This.Route_Plan_Responses)
                        then  All_Requests_Valid (This));
      end;
      
      pragma Assert (Contains (This.Route_Plan_Responses, Request_ID));
      pragma Assert (Contains (This.Pending_Route, Request_ID));
      pragma Assert (All_Requests_Valid (This));
               
      pragma Assert (for all Ind in First_Index (Get_RouteRequests (Route_Plan_Request)) ..  Last_Index (Get_RouteRequests (Route_Plan_Request))
                     => (not Contains (Container => This.Route_Plan,
                                       Key       => Get_RouteID ( Element (Get_RouteRequests (Route_Plan_Request), Ind)))));
      
      -- for (size_t k = 0; k < request->getRouteRequests ().size (); k++)
      for K in First_Index (Get_RouteRequests (Route_Plan_Request)) .. Last_Index (Get_RouteRequests (Route_Plan_Request)) loop
                   
         pragma Loop_Invariant ((for all I in First_Index (Get_RouteRequests (Route_Plan_Request)) .. Last_Index (Get_RouteRequests (Route_Plan_Request)) 
                                => (if I < K then
                                       Contains (Container => This.Route_Plan,
                                                 Key       => Get_RouteID (Element (Container => Get_RouteRequests (Route_Plan_Request),
                                                                                    Index     => I)))
                                    else 
                                      not Contains (Container => This.Route_Plan,
                                                    Key       => Get_RouteID (Element (Container => Get_RouteRequests (Route_Plan_Request),
                                                                                       Index     => I)))))
                                and Check_Route_Plan (This.Route_Plan,This.Pending_Route,THis.Route_Plan_Responses)
                                and All_Requests_Valid (This)
                                and Contains (This.Pending_Route,         Request_ID)
                                and Contains (This.Route_Plan_Responses,  Request_ID));
         declare
                     
            -- uxas::messages::route::RouteConstraints* routeRequest = request->getRouteRequests ().at (k);
            Route_Request : constant My_RouteConstraints := Element (Container => Get_RouteRequests (Route_Plan_Request),
                                                                     Index  => K);
                  
            Route_ID : constant Int64 := Get_RouteID (Route_Request);
            pragma Assert (Route_ID =  Get_RouteID (Element (Container => Get_RouteRequests (Route_Plan_Request),
                                                             Index     => K)));
                  
            -- Start_Point : Visibility.Point;
            -- End_Point : Visibility.Point;
                  
            -- uxas::messages::route::RoutePlan* plan = new uxas::messages::route::RoutePlan;
            Plan : My_RoutePlan;
                  
                     
            
            --  Earth_Circumference_M : constant Int64 :=  40_075_000 with Ghost;
            
            use Convert;
            
            
            Line_Dist : Linear_Distance_M;
         begin
            Set_RouteID (Plan, Route_ID);
            -- flatEarth.ConvertLatLong_degToNorthEast_m(routeRequest->getStartLocation()->getLatitude (), routeRequest->getStartLocation()->getLongitude (), north, east);
            -- Start_Point.set_X (Start_East);
            -- Start_Point.set_Y(Start_North);
             
            -- flatEarth.ConvertLatLong_degToNorthEast_m(routeRequest->getEndLocation()->getLatitude (), routeRequest->getEndLocation()->getLongitude (), north, east);
            -- End_Point.Set_X (End_East );
            -- End_Point.Set_Y(End_North);
           
            -- double linedist = VisiLibity::distance (startPt, endPt);
           
            Get_Linear_Distance_M_Lat1_Long1_DEG_To_Lat2_Long2_DEG (Latitude_1_DEG  => DEG_Angle_To_Latitude_Projection (Normalize_Angle_DEG (Long_Float (Get_Latitude  (Get_StartLocation(Route_Request))))),
                                                                    Longitude_1_DEG => Normalize_Angle_DEG (Long_Float  (Get_Longitude (Get_StartLocation(Route_Request)))),
                                                                    Latitude_2_DEG  => DEG_Angle_To_Latitude_Projection (Normalize_Angle_DEG (Long_Float (Get_Latitude  (Get_EndLocation  (Route_Request))))),
                                                                    Longitude_2_DEG => Normalize_Angle_DEG (Long_Float  (Get_Longitude (Get_EndLocation  (Route_Request)))),
                                                                    Linear_Distance => Line_Dist);
          
            pragma Assert ( Speed > 0.02);
            declare
              
               -- Line_Dist_Max : constant Int64 := 120_000_000 with Ghost; -- sqrt (12 848 045 000 000 000 ) = 113 349 217.0242035681614554
               -- Vitesse_Max : constant Int64 := 6_000_000_000_000 with Ghost; -- (Line_Dist_Max * 1 000) /0.02
               pragma Assert ((Line_Dist / Speed) * 1000.0 in 0.0 .. 6_000_000_000_000.0);
               pragma Assert (Int64 (6_000_000_000_000.0) in Int64'Range);
               pragma Assert (Long_Float (Int64'First) < (Line_Dist / Speed) * 1000.0);
               pragma Assert (Long_Float (Int64'Last)  > (Line_Dist / Speed) * 1000.0);
               
               pragma Assert (Int64'First < Int64 ((Line_Dist / Speed) * 1000.0));
               pragma Assert (Int64'Last  > Int64 ((Line_Dist / Speed) * 1000.0));
               
               pragma Assert (if (Line_Dist / Speed) * 1000.0 in 0.0 .. 6_000_000_000_000.0
                              and Int64 (6_000_000_000_000.0) in Int64'Range
                              and Int64 (0.0) in Int64'Range then
                                  Int64 ((Line_Dist / Speed) * 1000.0) in Int64'Range);
               pragma Assume (Int64 ((Line_Dist / Speed) * 1000.0) in Int64'Range);
               Vitesse : constant Int64 := Int64 ((Line_Dist / Speed) * 1000.0);
            begin
                  
               Set_RouteCost (Plan, Vitesse);
            end;
               
                  
                  
            declare
               Route_Plan_Pair : constant Pair_Int64_Route_Plan := Pair_Int64_Route_Plan'(Reponse_ID          => Request_ID,
                                                                                          Returned_Route_Plan => Plan);
               Position_Route_Plan : Int64_Pair_Int64_Route_Plan_Maps.Cursor;
               This_Route_Plan_Old : constant Pair_Int64_Route_Plan_Map := THis.Route_Plan with Ghost;
               use Int64_Pair_Int64_Route_Plan_Maps.Formal_Model;
            begin
                      
               pragma Assert (Route_Plan_Pair.Reponse_ID = Request_ID);
               pragma Assert (Contains (This.Pending_Route,        Route_Plan_Pair.Reponse_ID));
               pragma Assert (Contains (This.Route_Plan_Responses, Route_Plan_Pair.Reponse_ID));
      
               pragma Assert (Check_Route_Plan (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses));   
               pragma Assert (for all C in This.Route_Plan 
                              => Get_RouteID ( Element (This.Route_Plan, C).Returned_Route_Plan) = Key ( THis.Route_Plan, C)
                              and Contains (This.Pending_Route,        Element (This.Route_Plan, C).Reponse_ID)
                              and Contains (This.Route_Plan_Responses, Element (This.Route_Plan, C).Reponse_ID));
               pragma Assert (for all Key in Int64 
                              => (if Contains (This.Route_Plan, Key) then
                                     Int64_Pair_Int64_Route_Plan_Maps.Key (THis.Route_Plan, Find (This.Route_Plan, Key)) = Key 
                                  and Get_RouteID ( Element (This.Route_Plan,  Find (This.Route_Plan, Key)).Returned_Route_Plan) = Key
                                  and Contains (This.Pending_Route,        Element (This.Route_Plan,  Find (This.Route_Plan, Key)).Reponse_ID)
                                  and Contains (This.Route_Plan_Responses, Element (This.Route_Plan,  Find (This.Route_Plan, Key)).Reponse_ID)
                                  and Check_Route_Plan_Sub (Element (This.Route_Plan,  Find (This.Route_Plan, Key)), This.Pending_Route, This.Route_Plan_Responses, Key)));
                       
               pragma Assert (for all Key of Model (This.Route_Plan)
                              => Check_Route_Plan_Sub (Element (This.Route_Plan, Key), This.Pending_Route, This.Route_Plan_Responses, Key));
      
               Int64_Pair_Int64_Route_Plan_Maps.Insert
                 (Container => This.Route_Plan,
                  Key       => Get_RouteID (Route_Plan_Pair.Returned_Route_Plan),
                  New_Item  => Route_Plan_Pair);
               Position_Route_Plan := Find (Container => This.Route_Plan,
                                            Key       => Get_RouteID (Route_Plan_Pair.Returned_Route_Plan));
        
               Lemmma_Equal_RoutePlan (Element (This.Route_Plan, Position_Route_Plan).Returned_Route_Plan, Route_Plan_Pair.Returned_Route_Plan);
               pragma Assert (Has_Element (This.Route_Plan, Position_Route_Plan)
                              and Key (This.Route_Plan,Position_Route_Plan) = Get_RouteID (Route_Plan_Pair.Returned_Route_Plan)
                              and Key (This.Route_Plan,Position_Route_Plan) = Get_RouteID (Element (This.Route_Plan,Position_Route_Plan).Returned_Route_Plan)
                              and Contains (This.Pending_Route,        Element (This.Route_Plan,Position_Route_Plan).Reponse_ID)
                              and Contains (This.Route_Plan_Responses, Element (This.Route_Plan,Position_Route_Plan).Reponse_ID));
               pragma Assert (Contains (This.Route_Plan, Get_RouteID (Route_Plan_Pair.Returned_Route_Plan)));
               pragma Assert (Check_Route_Plan_Sub (Element (This.Route_Plan,Position_Route_Plan), This.Pending_Route,This.Route_Plan_Responses, Key ( This.Route_Plan,Position_Route_Plan)));
               --                    pragma Assert (for all C in This.Route_Plan 
               --                                   =>  Contains (This.Pending_Route,        Element (This.Route_Plan, C).Reponse_ID)
               --                                   and Contains (This.Route_Plan_Responses, Element (This.Route_Plan, C).Reponse_ID));
               pragma Assert (if (for all Cursor in This.Route_Plan
                              => Check_Route_Plan_Sub (Element (This.Route_Plan, Cursor),This.Pending_Route, This.Route_Plan_Responses, Key (This.Route_Plan , Cursor)))
                              then Check_Route_Plan   (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses));
               pragma Assert (if Check_Route_Plan   (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses) 
                              then  All_Requests_Valid (This));
         
               pragma Assert (Check_Entity_State  (This.Entity_State, This.Air_Vehicules, This.Ground_Vehicles, This.Surface_Vehicles));
               pragma Assert (Check_Pending_Route (This.Pending_Route,This.Route_Id));
               pragma Assert (Check_Task_Plan_Options    (This.Task_Plan_Options));
               pragma Assert (Check_Route_Task_Pairing   (This.Route_Task_Pairing, This.Entity_State, This.Route_Request_ID ));
               pragma Assert (Check_Route_Plan_Response  (This.Route_Plan_Responses));
               pragma Assert (Check_Entity_Configuration (This.Entity_Configuration, This.Air_Vehicules, This.Ground_Vehicles, This.Surface_Vehicles));
               pragma Assert (Check_List_Pending_Request (This.Pending_Auto_Req, This.Unique_Automation_Request, This.Route_Task_Pairing, This.Route_Request_ID));
               pragma Assert (Check_Unique_Automation_Request (This.Unique_Automation_Request, This.Auto_Request_Id));
       
               pragma Assert ( Model (This_Route_Plan_Old) <= Model (This.Route_Plan));
               pragma Assert ( Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Keys_Included_Except(Model (This.Route_Plan),
                               Model (This_Route_Plan_Old),
                               Get_RouteID (Route_Plan_Pair.Returned_Route_Plan)));
               pragma Assert ( Check_Route_Plan   (This_Route_Plan_Old,This.Pending_Route,THis.Route_Plan_Responses));
               pragma Assert  (for all Key of Model (This_Route_Plan_Old)
                               =>  (Contains (This.Route_Plan, Key)
                                    and Contains (This_Route_Plan_Old, Key)
                                    and Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Has_Key ( Model (This.Route_Plan), Key))
                               and then
                                 (Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Get (Model (This.Route_Plan), Key) = 
                                    Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Get (Model (This_Route_Plan_Old), Key)
                                  and (if Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Get (Model (This.Route_Plan), Key) = 
                                        Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Get (Model (This_Route_Plan_Old), Key) then
                                       Element (This.Route_Plan,  Key) = Element (This_Route_Plan_Old,  Key))
                                  and (if  Element (This.Route_Plan,  Key) = Element (This_Route_Plan_Old,  Key) then 
                                       Element (This.Route_Plan,  Key).Reponse_ID = Element (This_Route_Plan_Old,  Key).Reponse_ID
                                    and Element (This.Route_Plan,  Key).Returned_Route_Plan = Element (This_Route_Plan_Old,  Key).Returned_Route_Plan)
                                  and (if  Element (This.Route_Plan,  Key).Returned_Route_Plan = Element (This_Route_Plan_Old,  Key).Returned_Route_Plan then
                                       Same_Requests ( Element (This.Route_Plan,  Key).Returned_Route_Plan, Element (This_Route_Plan_Old,  Key).Returned_Route_Plan))
                                  and (if Same_Requests ( Element (This.Route_Plan,  Key).Returned_Route_Plan, Element (This_Route_Plan_Old,  Key).Returned_Route_Plan) then
                                         Get_RouteID ( Element (This.Route_Plan,  Key).Returned_Route_Plan) = Get_RouteID (Element (This_Route_Plan_Old,  Key).Returned_Route_Plan))
                                  and Check_Route_Plan_Sub (  Element (This_Route_Plan_Old,  Key) , This.Pending_Route, This.Route_Plan_Responses, Key)
                                  and (if Check_Route_Plan_Sub (  Element (This_Route_Plan_Old,  Key) , This.Pending_Route, This.Route_Plan_Responses, Key) then
                                         Get_RouteID (Element  (This_Route_Plan_Old, Key).Returned_Route_Plan) =  Key
                                    and Contains (This.Pending_Route,        Element (This_Route_Plan_Old, Key).Reponse_ID)
                                    and Contains (This.Route_Plan_Responses, Element (This_Route_Plan_Old, Key).Reponse_ID))
                                       
                                  and (if Contains (This.Pending_Route,        Element (This_Route_Plan_Old, Key).Reponse_ID)
                                    and Contains (This.Route_Plan_Responses, Element (This_Route_Plan_Old, Key).Reponse_ID)
                                    and Element (This.Route_Plan,  Key).Reponse_ID = Element (This_Route_Plan_Old,  Key).Reponse_ID
                                    then Contains (This.Pending_Route,        Element (This.Route_Plan, Key).Reponse_ID)
                                    and Contains (This.Route_Plan_Responses, Element (This.Route_Plan, Key).Reponse_ID))
                                       
                                  and (if  Get_RouteID (Element  (This_Route_Plan_Old, Key).Returned_Route_Plan) =  Get_RouteID (Element  (This.Route_Plan, Key).Returned_Route_Plan)
                                    and Get_RouteID (Element  (This_Route_Plan_Old, Key).Returned_Route_Plan) =  Key then
                                       Get_RouteID (Element  (This.Route_Plan    , Key).Returned_Route_Plan) =  Key)
                    
                                  and (if Element (This.Route_Plan,  Key).Reponse_ID = Element (This_Route_Plan_Old,  Key).Reponse_ID
                                    and Contains (This.Pending_Route,        Element (This_Route_Plan_Old, Key).Reponse_ID)
                                    and Contains (This.Route_Plan_Responses, Element (This_Route_Plan_Old, Key).Reponse_ID) then
                                       Contains (This.Pending_Route,        Element  (This.Route_Plan,    Key).Reponse_ID)
                                    and Contains (This.Route_Plan_Responses, Element  (This.Route_Plan,    Key).Reponse_ID))
                  
                                  and (if (Get_RouteID (Element  (This.Route_Plan, Key).Returned_Route_Plan) =  Key
                                    and Contains (This.Pending_Route,        Element (This.Route_Plan, Key).Reponse_ID)
                                    and Contains (This.Route_Plan_Responses, Element (This.Route_Plan, Key).Reponse_ID))
                                    then Check_Route_Plan_Sub( Element (This.Route_Plan, Key),This.Pending_Route, This.Route_Plan_Responses, Key)        
                                    and  Check_Route_Plan_Sub( Element (This_Route_Plan_Old, Key),This.Pending_Route, This.Route_Plan_Responses, Key))));
     
               pragma Assert  (for all C in This.Route_Plan
                               => (if  Key (This.Route_Plan, C) = Get_RouteID (Route_Plan_Pair.Returned_Route_Plan)
                                   then
                                      Check_Route_Plan_Sub (Element  (This.Route_Plan, Key (This.Route_Plan, C)),This.Pending_Route,This.Route_Plan_Responses, Key (This.Route_Plan, C))
                                   else
                                      Check_Route_Plan_Sub (Element  (This.Route_Plan, Key (This.Route_Plan, C)),This.Pending_Route,This.Route_Plan_Responses, Key (This.Route_Plan, C))));
   
      
   
               pragma Assert  (for all Cursor in This.Route_Plan
                               => Check_Route_Plan_Sub (Element (This.Route_Plan, Cursor),This.Pending_Route, This.Route_Plan_Responses, Key (This.Route_Plan , Cursor)));
               pragma Assert  (if (for all Cursor in This.Route_Plan
                               => Check_Route_Plan_Sub (Element (This.Route_Plan, Cursor),This.Pending_Route, This.Route_Plan_Responses, Key (This.Route_Plan , Cursor)))
                               then Check_Route_Plan     (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses));
               pragma Assert  (if Check_Route_Plan   (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses)
                               then  All_Requests_Valid (This));
           
               
            end;
            pragma Assert ( All_Requests_Valid (This));
                 
         end;
                     
         -- loop invariant
         pragma Assert (Contains (Container => This.Route_Plan,
                                  Key       => Get_RouteID (Element (Container => Get_RouteRequests (Route_Plan_Request),
                                                                     Index     => K)))); 
                     
         pragma Assert (for all I in First_Index (Get_RouteRequests (Route_Plan_Request)) .. Last_Index (Get_RouteRequests (Route_Plan_Request)) 
                        => (if I <= K  then
                               Contains (Container => This.Route_Plan,
                                         Key       => Get_RouteID (Element (Container => Get_RouteRequests (Route_Plan_Request),
                                                                            Index     => I)))
                            else 
                              not Contains (Container => This.Route_Plan,
                                            Key       => Get_RouteID (Element (Container => Get_RouteRequests (Route_Plan_Request),
                                                                               Index     => I)))));
                  
      end loop;
                  
   end Euclidean_Plan;
         
   --     --------------------------
   --     -- Handle_Route_Request --
   --     --------------------------
   --        
   --     procedure Handle_Route_Request
   --       (This          : in out Route_Aggregator_Service;
   --        Route_Request : My_RouteRequest)
   --     is
   --        use Int64_Vects;
   --        use Int64_Entity_State_Maps;
   --        
   --        
   --        -- TODO : Put Euclidean_Plan Here
   --        
   --       
   --              
   --        
   --        procedure My_Send_LMCP_Object_Limited_Cast_Message
   --          (This : in out Route_Aggregator_Service;
   --           CastAddress : String;
   --           Request : My_RoutePlanRequest);
   --        
   --        procedure My_Send_LMCP_Object_Limited_Cast_Message
   --          (This : in out Route_Aggregator_Service;
   --           CastAddress : String;
   --           Request : My_RoutePlanRequest) with
   --          SPARK_Mode => Off
   --          
   --        is
   --           Request_Acc : constant RoutePlanRequest_Acc := new RoutePlanRequest;
   --        begin
   --           Request_Acc.all := Unwrap (Request);
   --           This.Send_LMCP_Object_Limited_Cast_Message (CastAddress => CastAddress,
   --                                                       Msg         => Object_Any(Request_Acc));
   --        end My_Send_LMCP_Object_Limited_Cast_Message;
   --        
   --        
   --        Vect_VehiclesID : Int64_Vect := Get_VehicleID (Route_Request);
   --        
   --     begin
   --       
   --        --  if (request->getVehicleID ().empty())
   --        if Length(Vect_VehiclesID) = 0 then
   --        
   --           --request->getVehicleId ().reserve (m_entityStates.size ());
   --        
   --           declare
   --              C : Int64_Entity_State_Maps.Cursor := First (This.Entity_State);
   --           begin
   --              -- for (const auto& v : m_entityStates)
   --              while Has_Element (Container => This.Entity_State,
   --                                 Position  => C) loop
   --        
   --                 -- request->getVehicleID ().push_back(v.second->getID ());
   --                 Int64_Vects.Append (Container => Vect_VehiclesID,
   --                                     New_Item  => Get_ID (Element (Container => This.Entity_State,
   --                                                                   Position  => C).Content) );
   --                 
   --                 Next (Container => This.Entity_State,
   --                       Position  => C);
   --              end loop;
   --           end;
   --        end if;
   --        
   --        declare 
   --           --  m_pendingRoute[request->getRequestID ()]
   --           Pending_Route_Request : Int64_Set := Int64_Pending_Route_Matrix.Element (Container => This.Pending_Route,
   --                                                                                    Key       => Get_RequestID (Route_Request));
   --        begin
   --           
   --        
   --           for Id_Indx in First_Index (Vect_VehiclesID) .. Last_Index (Vect_VehiclesID)  loop
   --        
   --        
   --              declare
   --        
   --                 Vehicles_Id : constant Int64 := Element (Container => Vect_VehiclesID,
   --                                                          Index     => Id_Indx);
   --              
   --                 -- std::shared_ptr<uxas::messages::route::RoutePlanRequest> planRequest (new uxas::messages::route::RoutePlanRequest);
   --                 Plan_Request : My_RoutePlanRequest;
   --        
   --        
   --             
   --        
   --                 use Vect_My_RouteConstraints_P;
   --              begin
   --        
   --                 -- planRequest->setAssociatedTaskID (request->getAssociatedTaskID ());
   --                 -- planRequest->setIsCostOnlyRequest (request->getIsCostOnlyRequest ());
   --                 -- planRequest->setOperatingRegion(request->getOperatingRegion());
   --                 -- planRequest->setVehicleID (vehicleId);
   --                 -- planRequest->setRequestID (m_routeRequestId);
   --                 Set_AssociatedTaskID  (Plan_Request, Get_AssociatedTaskID  (Route_Request));
   --                 Set_IsCostOnlyRequest (Plan_Request, Get_IsCostOnlyRequest (Route_Request));
   --                 Set_OperatingRegion   (Plan_Request, Get_OperatingRegion   (Route_Request));
   --                 Set_VehicleID         (Plan_Request, Vehicles_Id);
   --                 Set_RequestID         (Plan_Request, This.Route_Request_ID);
   --              
   --        
   --                 --  m_pendingRoute[request->getRequestID ()].insert (m_routeRequestId);
   --                 Int64_Sets.Insert (Container => Pending_Route_Request,
   --                                    New_Item  => This.Route_Request_ID);
   --           
   --                 -- m_routeRequestId++;
   --                 This.Route_Request_ID := This.Route_Request_ID + 1;
   --        
   --        
   --                 for Indx in First_Index (Get_RouteRequests (Route_Request)) .. Last_Index (Get_RouteRequests (Route_Request))  loop
   --                    -- planRequest->getRouteRequests ().push_back(r->clone ());
   --                    Append_RouteRequests (This          => Plan_Request,
   --                                          RouteRequests => Element (Container => Get_RouteRequests (Route_Request),
   --                                                                    Index     => Indx));
   --                 end loop;
   --        
   --            
   --        
   --        
   --                 --  if (m_groundVehicles.find (vehicleId) != m_groundVehicles.end ())
   --                 if Int64_Sets.Contains (Container => This.Ground_Vehicles,
   --                                         Item      => Vehicles_Id)
   --                 then
   --        
   --                    -- if (m_fastPlan)
   --                    if This.Fast_Plan then
   --                       -- Replace here cause for proving Euclidean_Plan wee need to have a Pending_Route up to date
   --                       Int64_Pending_Route_Matrix.Replace (Container => This.Pending_Route,
   --                                                           Key       => Get_RequestID (Route_Request),
   --                                                           New_Item  => Pending_Route_Request);
   --        
   --                       -- // short-circuit and just plan with straight line planner
   --                       -- EuclideanPlan(PlanRequest);
   --                       Euclidean_Plan(This               => This,
   --                                      Route_Plan_Request => Plan_Request);
   --        
   --                    else
   --        
   --                       -- // send externally
   --                       -- sendSharedLmcpObjectLimitedCastMessage (uxas::common::MessageGroup::GroundPathPlanner(), pRequest);
   --                       My_Send_LMCP_Object_Limited_Cast_Message (This,
   --                                                                 GroundPathPlanner,
   --                                                                 Plan_Request);
   --        
   --                    end if;
   --                 else
   --        
   --                    -- // send to aircraft planner
   --                    -- sendSharedLmcpObjectLimitedCastMessage (uxas::common::MessageGroup::AircraftPathPlanner(), pRequest);
   --                    My_Send_LMCP_Object_Limited_Cast_Message (This,
   --                                                              AircraftPathPlanner,
   --                                                              Plan_Request);
   --                 end if;
   --              end;
   --        
   --           end loop;
   --                                      
   --           Int64_Pending_Route_Matrix.Replace (Container => This.Pending_Route,
   --                                               Key       => Get_RequestID (Route_Request),
   --                                               New_Item  => Pending_Route_Request);
   --        end;
   --        
   --        
   --        if (This.Fast_Plan) then
   --           Check_All_Route_Plans (This);
   --        end if;
   --     end Handle_Route_Request;
   
   


end UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK;
