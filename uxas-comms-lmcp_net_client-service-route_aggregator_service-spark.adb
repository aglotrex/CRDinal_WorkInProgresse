with Ada.Numerics.Long_Elementary_Functions;                     use Ada.Numerics.Long_Elementary_Functions;
with Ada.Strings.Unbounded;                                      use Ada.Strings.Unbounded;
with Ada.Text_IO;                                                use Ada.Text_IO;
with Ada.Containers.Formal_Vectors;

with Common_Formal_Containers;                                   use Common_Formal_Containers;

with Uxas.Messages.Lmcptask.TaskOption;                          use Uxas.Messages.Lmcptask.TaskOption;
with Uxas.Messages.Lmcptask.TaskOptionCost;                      use Uxas.Messages.Lmcptask.TaskOptionCost;
with Uxas.Messages.Lmcptask.AssignmentCostMatrix;                use Uxas.Messages.Lmcptask.AssignmentCostMatrix;
with Uxas.Messages.Lmcptask.PlanningState.SPARK_Boundary;        use Uxas.Messages.Lmcptask.PlanningState.SPARK_Boundary;

with Uxas.Messages.Route.RouteResponse;                          use Uxas.Messages.Route.RouteResponse;
with Uxas.Messages.Route.RouteResponse.SPARK_Boundary;           use Uxas.Messages.Route.RouteResponse.SPARK_Boundary;

with Uxas.Messages.Lmcptask.TaskOption.SPARK_Boundary;           use Uxas.Messages.Lmcptask.TaskOption.SPARK_Boundary;
with Uxas.Messages.Lmcptask.TaskPlanOptions.SPARK_Boundary;      use Uxas.Messages.Lmcptask.TaskPlanOptions.SPARK_Boundary;
with Uxas.Messages.Lmcptask.TaskOptionCost.SPARK_Boundary;       use Uxas.Messages.Lmcptask.TaskOptionCost.SPARK_Boundary;
with Uxas.Messages.Lmcptask.AssignmentCostMatrix.SPARK_Boundary; use Uxas.Messages.Lmcptask.AssignmentCostMatrix.SPARK_Boundary;
with Uxas.Common.Utilities.Unit_Conversions;                     use Uxas.Common.Utilities.Unit_Conversions;

with Uxas.Common.String_Constant.Message_Group;                  use Uxas.Common.String_Constant.Message_Group;

with Afrl.Cmasi.Enumerations;                                    use Afrl.Cmasi.Enumerations;
with Afrl.Cmasi.ServiceStatus;                                   use Afrl.Cmasi.ServiceStatus;
with Afrl.Cmasi.KeyValuePair;                                    use Afrl.Cmasi.KeyValuePair;
with Afrl.Cmasi.Location3D;                                      use Afrl.Cmasi.Location3D;
with Afrl.Cmasi.AutomationRequest;                               use Afrl.Cmasi.AutomationRequest;
with Afrl.Cmasi.Location3D.SPARK_Boundary;                       use Afrl.Cmasi.Location3D.SPARK_Boundary;
with Afrl.Cmasi.ServiceStatus.SPARK_Boundary;                    use Afrl.Cmasi.ServiceStatus.SPARK_Boundary;
use  Afrl.Cmasi.AutomationRequest.Vect_Int64;

with Convert;
use Ada.Containers;
with Ada.Containers;
with UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Vects;  use uxas.messages.route.RouteConstraints.SPARK_Boundary.Vects;
with UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary;        use uxas.messages.route.RoutePlanRequest.SPARK_Boundary;

package body Uxas.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK with SPARK_Mode is

   package My_Task_Option_Vects is new Ada.Containers.Formal_Vectors
     (Index_Type   => Natural,
      Element_Type => My_TaskOption);

   package My_Plan_Request_Vects is new Ada.Containers.Formal_Vectors
     (Index_Type   => Natural,
      Element_Type => My_RoutePlanRequest);

   use My_Plan_Request_Vects;
   use Int64_Pending_Route_Matrix.Formal_Model;
   use Int64_Route_Plan_Responses_Maps.Formal_Model;

   procedure Lemma_Ceck_Route_Plan_Reference_Insert (Route_Plan : Pair_Int64_Route_Plan_Map;
                                                     Old_Pending_Route,  New_Pending_Route : Pending_Route_Matrix;
                                                     Old_Route_Plan_Rep, New_Route_Plan_Rep : Route_Plan_Responses_Map)
     with Ghost,
     Global => null,
     Pre => Check_Route_Plan (Route_Plan, Old_Pending_Route, Old_Route_Plan_Rep)
     and K_Keys_Included (Keys (Old_Pending_Route),  Keys (New_Pending_Route))
     and K_Keys_Included (Keys (Old_Route_Plan_Rep), Keys (New_Route_Plan_Rep)),
     PosT => Check_Route_Plan (Route_Plan, New_Pending_Route, New_Route_Plan_Rep);

   --  check that to see if all options from all tasks have been received for this request
   function All_Task_Option_Receive (This    : Route_Aggregator_Service;
                                     Request : My_UniqueAutomationRequest) return Boolean is
     (for all T in (Int64_Vects.First_Index (Get_TaskList_From_OriginalRequest (Request))
                    .. Int64_Vects.Last_Index (Get_TaskList_From_OriginalRequest (Request)))
      => Int64_Task_Plan_Options_Maps.Contains (Container => This.Task_Plan_Options,
                                                Key       => Int64_Vects.Element (Container => Get_TaskList_From_OriginalRequest (Request),
                                                                                  Index     => T))) with Global => null;

   procedure Lemma_Ceck_Route_Plan_Reference_Insert (Route_Plan : Pair_Int64_Route_Plan_Map;
                                                     Old_Pending_Route, New_Pending_Route : Pending_Route_Matrix;
                                                     Old_Route_Plan_Rep, New_Route_Plan_Rep : Route_Plan_Responses_Map)
   is
   begin

      pragma Assert (for all Cursor in Route_Plan
                     => Check_Route_Plan_Sub (Element (Route_Plan, Cursor), Old_Pending_Route, Old_Route_Plan_Rep, Key (Route_Plan, Cursor))
                     and Contains (New_Pending_Route,  Element (Route_Plan, Cursor).Reponse_ID)
                     and Contains (New_Route_Plan_Rep, Element (Route_Plan, Cursor).Reponse_ID)
                     and Check_Route_Plan_Sub (Element (Route_Plan, Cursor), New_Pending_Route, New_Route_Plan_Rep, Key (Route_Plan, Cursor)));
   end Lemma_Ceck_Route_Plan_Reference_Insert;

   ---------------------------
   -- Build_Matrix_Requests --
   ---------------------------

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

   procedure Build_Matrix_Requests (This  : in out Route_Aggregator_Service;
                                    ReqID : Int64;
                                    Areq  : My_UniqueAutomationRequest) with
     Pre => All_Requests_Valid (This)

     --  Check that Calculation Was Never Done Before
     and not Int64_Pending_Auto_Req_Matrix.Contains (This.Pending_Auto_Req,
                                                     ReqID)

     -- check if the call is legit
     and All_Task_Option_Receive (This, Areq),

     Post => All_Requests_Valid (This);

   procedure Build_Matrix_Requests (This  : in out Route_Aggregator_Service;
                                    ReqID : Int64;
                                    Areq  : My_UniqueAutomationRequest)

   is

      procedure My_Send_Shared_LMCP_Object_Limited_Cast_Message
        (This : in out Route_Aggregator_Service;
         Cast_Address : String;
         Request : My_RoutePlanRequest) with
        Post => (if All_Requests_Valid (This)'Old then All_Requests_Valid (This));

      procedure My_Send_Shared_LMCP_Object_Limited_Cast_Message
        (This : in out Route_Aggregator_Service;
         Cast_Address : String;
         Request : My_RoutePlanRequest) with
        SPARK_Mode => Off
      is
         Request_Acc : constant RoutePlanRequest_Acc := new RoutePlanRequest;
      begin
         Request_Acc.all := Unwrap (Request);
         This.Send_Shared_LMCP_Object_Limited_Cast_Message (Cast_Address,
                                                            Object_Any (Request_Acc));

      end My_Send_Shared_LMCP_Object_Limited_Cast_Message;

      My_Plan_Request_Vects_Commun_Max_Capacity : constant := 200; -- arbitrary

      subtype My_Plan_Request_Vect is My_Plan_Request_Vects.Vector
        (My_Plan_Request_Vects_Commun_Max_Capacity);

      Send_Air_Plan_Request    : My_Plan_Request_Vect := My_Plan_Request_Vects.Empty_Vector;
      Send_Ground_Plan_Request : My_Plan_Request_Vect := My_Plan_Request_Vects.Empty_Vector;
      use Int64_Vects;

      Entity_List : Int64_Vect := Get_EntityList_From_OriginalRequest (Request => Areq);
   begin

      --  if the list of eligible vehicles is empty that mean they are all eligible
      if Is_Empty (Entity_List) then

         for State_Cursor in This.Entity_State loop
            Append (Entity_List,
                    Get_ID (Int64_Entity_State_Maps.Element (Container => This.Entity_State,
                                                             Position  => State_Cursor).Content));

         end loop;

      end if;

      for Index_EntityList in First_Index (Entity_List) .. Last_Index (Entity_List) loop

         declare
            Vehicle_ID : constant Int64 := Element (Entity_List, Index_EntityList);
            Vehicles : My_EntityState;
            Contains_Vehicles : constant Boolean := Int64_Entity_State_Maps.Contains (Container => This.Entity_State,
                                                                                      Key  => Vehicle_ID);
            Start_Heading_DEG : Real32 := 0.0;

            Start_Location : My_Location3D_Any;

            Is_Foud_Planning_State : Boolean := False;

            use My_Task_Option_Vects;

            My_Task_Option_Vects_Commun_Max_Capacity : constant := 200; -- arbitrary

            subtype My_Task_Option_Vect is My_Task_Option_Vects.Vector
              (My_Task_Option_Vects_Commun_Max_Capacity);

            Task_Option_List : My_Task_Option_Vect;

            use Int64_Task_Plan_Options_Maps;
            use all type Vect_My_PlanningState;
         begin

            --  collect the data about the current vehicles
            for Index_Planning_State in First_Index (Get_PlanningStates (Areq)) .. Last_Index (Get_PlanningStates (Areq)) loop
               declare
                  Planning_State : constant My_PlanningState := Element (Get_PlanningStates (Areq), Index_Planning_State);
               begin

                  if Get_EntityId (Planning_State) = Vehicle_ID then
                     Start_Location    := Get_PlanningPosition (Planning_State);
                     Start_Heading_DEG := Get_PlanningHeading  (Planning_State);
                     Is_Foud_Planning_State := True;
                     exit;
                  end if;
               end;
            end loop;

            --  if we got the information about vehicles we can processe calcultion
            if Is_Foud_Planning_State or Contains_Vehicles then

               for  Index_Task_ID in (First_Index (Get_TaskList_From_OriginalRequest (Areq))
                                      .. Last_Index (Get_TaskList_From_OriginalRequest (Areq)))
               loop

                  declare
                     Task_ID : constant Int64 := Element (Get_TaskList_From_OriginalRequest (Areq), Index_Task_ID);
                  begin
                     if Contains (This.Task_Plan_Options,
                                  Task_ID)
                     then
                        declare
                           Tasks_List : constant Vect_My_TaskOption := Get_Options (Element (This.Task_Plan_Options,
                                                                                    Task_ID).Content);
                           use Vect_My_TaskOptions;
                        begin

                           for Index_Task in First_Index (Tasks_List) .. Last_Index (Tasks_List) loop
                              declare
                                 Option : constant My_TaskOption := Element (Container => Tasks_List,
                                                                             Index     => Index_Task);
                              begin
                                 if Is_Empty (Get_EligibleEntities (Option))
                                   or Contains (Container => Get_EligibleEntities (Option),
                                                Item => Vehicle_ID)
                                 then
                                    My_Task_Option_Vects.Append (Container => Task_Option_List,
                                                                 New_Item  => Option); -- TODO clone here
                                 end if;
                              end;

                           end loop;
                        end;

                     end if;
                  end;
               end loop;

               --    // create a new route plan request
               declare

                  Plan_Request : My_RoutePlanRequest;

                  List_Pending_Request : Int64_Set := Int64_Pending_Auto_Req_Matrix.Element (Container => This.Pending_Auto_Req,
                                                                                             Key       => ReqID);
               begin

                  Set_AssociatedTaskID (Plan_Request,  0);
                  Set_IsCostOnlyRequest (Plan_Request, False);
                  Set_OperatingRegion   (Plan_Request, Get_OperatingRegion_From_OriginalRequest (Areq));
                  Set_VehicleID (Plan_Request, Vehicle_ID);
                  --  //planRequest->setRouteID (m_planrequestId);
                  --  //m_planrequestId++;

                  if not Is_Foud_Planning_State then
                     Vehicles := Int64_Entity_State_Maps.Element (Container => This.Entity_State,
                                                                  Key       =>  Vehicle_ID).Content;

                     Start_Location := Get_Location (Vehicles);
                     Start_Heading_DEG := Get_Heading (Vehicles);
                  end if;

                  --  a aggregator for the vehicle position to eache task
                  --  and a between evry task
                  --  then create a Route_Constraints for each
                  --  they store each of them the same ID
                  for Id_Opt_1  in First_Index (Task_Option_List) .. Last_Index (Task_Option_List) loop

                     --  // find routes from initial conditions
                     declare
                        Option_1 : constant My_TaskOption := Element (Task_Option_List, Id_Opt_1);
                     begin
                        declare
                           --  // build map from request to full task/option information
                           Task_Option_Pair : constant AggregatorTaskOptionPair
                             := AggregatorTaskOptionPair'(VehicleId      => Vehicle_ID,
                                                          PrevTaskId     => 0,
                                                          PrevTaskOption => 0,
                                                          TaskId         => Get_TaskID   (Option_1),
                                                          TaskOption     => Get_OptionID (Option_1));

                           Route_Constraints : My_RouteConstraints;
                           --:= UxAS.Messages.Route.RouteConstraints.Spark_Boundary.Wrap ( RouteConstraints );
                           use Int64_Aggregator_Task_Option_Pair_Maps;
                        begin

                           Include (Container => This.Route_Task_Pairing,
                                    Key       => This.Route_Id,
                                    New_Item  => Task_Option_Pair);

                           Set_StartLocation (Route_Constraints, Start_Location);
                           Set_StartHeading  (Route_Constraints, Start_Heading_DEG);
                           Set_EndLocation   (Route_Constraints, Get_StartLocation (Option_1));
                           Set_EndHeading    (Route_Constraints, Get_StartHeading  (Option_1));
                           Set_RouteID       (Route_Constraints, This.Route_Id);
                           Append_RouteRequests (This          => Plan_Request,
                                                 RouteRequests => Route_Constraints);

                        end;

                        Int64_Sets.Include (Container => List_Pending_Request,
                                            New_Item  => This.Route_Id);

                        This.Route_Id := This.Route_Id + 1;

                        --  combination routes
                        for Id_Opt_2  in First_Index (Task_Option_List) .. Last_Index (Task_Option_List) loop

                           if not (Id_Opt_1 = Id_Opt_2) then
                              declare
                                 Option_2 : constant My_TaskOption := Element (Task_Option_List, Id_Opt_2);

                                 --  // build map from request to full task/option information

                                 Task_Option_Pair : constant AggregatorTaskOptionPair
                                   := AggregatorTaskOptionPair'(VehicleId      => Vehicle_ID,
                                                                PrevTaskId     => Get_OptionID (Option_1),
                                                                PrevTaskOption => Get_TaskID   (Option_1),
                                                                TaskId         => Get_OptionID (Option_2),
                                                                TaskOption     => Get_TaskID   (Option_2));
                                 Route_Constraints : My_RouteConstraints;

                              begin

                                 Int64_Aggregator_Task_Option_Pair_Maps.Insert (Container => This.Route_Task_Pairing,
                                                                                Key       => This.Route_Id,
                                                                                New_Item  => Task_Option_Pair);

                                 Set_StartLocation (Route_Constraints, Get_EndLocation (Option_1));
                                 Set_StartHeading  (Route_Constraints, Get_EndHeading  (Option_1));
                                 Set_EndLocation   (Route_Constraints, Get_StartLocation (Option_2));
                                 Set_EndHeading    (Route_Constraints, Get_StartHeading  (Option_2));
                                 Set_RouteID       (Route_Constraints, This.Route_Id);

                                 Append_RouteRequests (Plan_Request, Route_Constraints);

                              end;
                              Int64_Sets.Include (Container => List_Pending_Request,
                                                  New_Item  => This.Route_Id);
                              This.Route_Id := This.Route_Id + 1;
                           end if;
                        end loop;
                     end;
                  end loop;

                  --  the list of ID is add to Pending_Auto_Req at the Request ID

                  Int64_Pending_Auto_Req_Matrix.Replace (Container => This.Pending_Auto_Req,
                                                         Key       => ReqID,
                                                         New_Item  => List_Pending_Request);

                  --  in fuction of is type the vehicles is add to the coresponding list for future handeling
                  if Int64_Sets.Contains (Container => This.Ground_Vehicles,
                                          Item      => Vehicle_ID)
                  then
                     My_Plan_Request_Vects.Append (Container => Send_Ground_Plan_Request,
                                                   New_Item  => Plan_Request);
                  else
                     My_Plan_Request_Vects.Append (Container => Send_Air_Plan_Request,
                                                   New_Item  => Plan_Request);
                  end if;
               end;

            end if;

         end;

      end loop;

      for Id_Req in First_Index (Send_Air_Plan_Request) .. Last_Index (Send_Air_Plan_Request) loop
         My_Send_Shared_LMCP_Object_Limited_Cast_Message (This,
                                                          AircraftPathPlanner,
                                                          Element (Send_Air_Plan_Request, Id_Req));
      end loop;

      for Id_Req in First_Index (Send_Ground_Plan_Request) .. Last_Index (Send_Ground_Plan_Request) loop
         My_Send_Shared_LMCP_Object_Limited_Cast_Message (This,
                                                          GroundPathPlanner,
                                                          Element (Send_Ground_Plan_Request, Id_Req));
      end loop;

      if This.Fast_Plan then
         Check_All_Route_Plans (This);

      end if;

   end Build_Matrix_Requests;

   ------------------------
   -- Send_Route_Reponse --
   ------------------------
   function All_Route_Response_Receive (This : Route_Aggregator_Service;
                                        Route_Id : Int64) return Boolean is
     (for all Id_Request of Int64_Pending_Route_Matrix.Element (This.Pending_Route, Route_Id)
      => Int64_Route_Plan_Responses_Maps.Contains (Container => This.Route_Plan_Responses,
                                                   Key       => Id_Request)) with Global => null,
     Pre => Int64_Pending_Route_Matrix.Contains (This.Pending_Route, Route_Id);

   procedure Send_Route_Reponse (This     : in out Route_Aggregator_Service;
                                 RouteKey : Int64) with
     Pre =>
       Int64_Pending_Route_Matrix.Contains (This.Pending_Route,
                                            RouteKey)
     -- Check if The call is legit
     and then  All_Route_Response_Receive (This, RouteKey)
     and then
       (for all Cursor in Element (This.Pending_Route, RouteKey)
        => ( -- check of calculation
                  for all J in
                    Int64_Vects.First_Index (Get_ID_From_RouteResponses
                                             (Int64_Route_Plan_Responses_Maps.Element
                                              (This.Route_Plan_Responses,
                                               Element (Element (This.Pending_Route, RouteKey), Cursor)).Content)) ..
              Int64_Vects.Last_Index (Get_ID_From_RouteResponses
                                      (Int64_Route_Plan_Responses_Maps.Element
                                       (This.Route_Plan_Responses,
                                        Element (Element (This.Pending_Route, RouteKey), Cursor)).Content))
            => Contains (This.Route_Plan,
                         Int64_Vects.Element (Get_ID_From_RouteResponses
                                              (Int64_Route_Plan_Responses_Maps.Element
                                               (This.Route_Plan_Responses,
                                                Element (Element (This.Pending_Route, RouteKey), Cursor)).Content), J))))
        ,
     Post => Int64_Pending_Route_Matrix.Contains (This.Pending_Route,
                                                  RouteKey);

   --  create a response to the Request with RouteKey as ID
   procedure Send_Route_Reponse (This : in out Route_Aggregator_Service;
                                 RouteKey : Int64)
   is
      procedure My_Send_LMCP_Object_Broadcast_Message
        (This : in out Route_Aggregator_Service;
         Request : My_RouteResponse);

      procedure My_Send_LMCP_Object_Broadcast_Message
        (This : in out Route_Aggregator_Service;
         Request : My_RouteResponse)
        with
          SPARK_Mode => Off

      is
         Request_Acc : constant RouteResponse_Acc := new RouteResponse;
      begin
         Request_Acc.all := Unwrap (Request);

         This.Send_LMCP_Object_Broadcast_Message (Object_Any (Request_Acc));
      end My_Send_LMCP_Object_Broadcast_Message;

      Response  : My_RouteResponse;
      Exepcted_Plan_Response_IDs : constant Int64_Set := Int64_Pending_Route_Matrix.Element (This.Pending_Route,
                                                                                             RouteKey);

   begin

      --  response->setResponseID (routeKey);
      Set_ResponseID (Response, RouteKey);

      --  add Each plan concerne by responce
      --  remove these plan and all the route constrain of it
      for Plan_Reponse_Id of Exepcted_Plan_Response_IDs loop

         declare
            Plan : constant My_RoutePlanResponse := Int64_Route_Plan_Responses_Maps.Element (This.Route_Plan_Responses,
                                                                                             Plan_Reponse_Id).Content;
            use Int64_Vects;

            Route_Responses_ID : constant Int64_Vect := Get_ID_From_RouteResponses (Plan);

         begin

            Add_Route (Response, Plan);    -- clone here

            --  // delete all individual routes from storage
            --  for (auto& i : plan->second->getRouteResponses ())

            for Index_Route_ID in First_Index (Route_Responses_ID) .. Last_Index (Route_Responses_ID) loop

               --  M_RoutePlans.Erase (I->GetRouteID ());
               Int64_Pair_Int64_Route_Plan_Maps.Delete (This.Route_Plan,
                                                        Element (Container => Route_Responses_ID,
                                                                 Index     => Index_Route_ID));
            end loop;

            --   m_routePlanResponses.erase (plan);
            Int64_Route_Plan_Responses_Maps.Delete (This.Route_Plan_Responses,
                                                    Plan_Reponse_Id);
         end;
         --  end if;
      end loop;

      --  send the responce
      My_Send_LMCP_Object_Broadcast_Message  (This,
                                              Response);

   end Send_Route_Reponse;

   -----------------
   -- Send_Matrix --
   -----------------

   function All_Matrix_Response_Receive (This   : Route_Aggregator_Service;
                                         Req_ID : Int64) return Boolean is
     (for all Id_Request of Int64_Pending_Auto_Req_Matrix.Element (This.Pending_Auto_Req, Req_ID)
      => Int64_Pair_Int64_Route_Plan_Maps.Contains (Container => This.Route_Plan,
                                                    Key       => Id_Request)) with Global => null,
     Pre => Int64_Pending_Auto_Req_Matrix.Contains (This.Pending_Auto_Req, Req_ID);

   procedure Send_Matrix (This    : in out Route_Aggregator_Service;
                          AutoKey : Int64) with
     Pre => All_Requests_Valid (This)
     and then Contains (This.Pending_Auto_Req,
                        AutoKey)
     and then
       Contains (This.Unique_Automation_Request,
                 AutoKey)
     and then All_Matrix_Response_Receive (This, AutoKey),

     Post => All_Requests_Valid (This);

   --  build the matrix response for the AutoKey request
   procedure Send_Matrix (This : in out Route_Aggregator_Service;
                          AutoKey : Int64)
   is

      procedure My_Send_Shared_LMCP_Object_Broadcast_Message
        (This : in out Route_Aggregator_Service;
         Matrix : My_AssignmentCostMatrix);
      procedure My_Send_LMCP_Object_Broadcast_Message
        (This : in out Route_Aggregator_Service;
         Service_Status : My_ServiceStatus);

      procedure My_Send_Shared_LMCP_Object_Broadcast_Message
        (This : in out Route_Aggregator_Service;
         Matrix : My_AssignmentCostMatrix) with
        SPARK_Mode => Off
      is
         Matrix_Acc : constant AssignmentCostMatrix_Acc := new AssignmentCostMatrix;

      begin
         Matrix_Acc.all := Unwrap (Matrix);
         This.Send_Shared_LMCP_Object_Broadcast_Message (Object_Any (Matrix_Acc));
      end My_Send_Shared_LMCP_Object_Broadcast_Message;

      procedure My_Send_LMCP_Object_Broadcast_Message
        (This : in out Route_Aggregator_Service;
         Service_Status : My_ServiceStatus) with
        SPARK_Mode => Off
      is
         Service_Status_Acc : constant ServiceStatus_Acc := new ServiceStatus;
      begin
         Service_Status_Acc.all := Unwrap (Service_Status);
         This.Send_Shared_LMCP_Object_Broadcast_Message (Object_Any (Service_Status_Acc));
      end My_Send_LMCP_Object_Broadcast_Message;

      --   auto matrix = std::shared_ptr<uxas::messages::task::AssignmentCostMatrix>(new uxas::messages::task::AssignmentCostMatrix);
      Matrix :  My_AssignmentCostMatrix;

      --   auto& areq = m_uniqueAutomationRequests[autoKey];
      Areq   : constant My_UniqueAutomationRequest :=
        Int64_Unique_Automation_Request_Maps.Element (Container => This.Unique_Automation_Request,
                                                      Key       => AutoKey).Content;
      Route_Not_Found : Unbounded_String := To_Unbounded_String ("");

      Service_Status  : My_ServiceStatus;

   begin

      Set_CorrespondingAutomationRequestID (Matrix, GetRequestID (Areq));
      Set_OperatingRegion (Matrix, Get_OperatingRegion_From_OriginalRequest (Areq));
      Set_TaskLevelRelationship (Matrix, Get_TaskRelationship_From_OriginalRequest (Areq));
      Set_TaskList (Matrix, Get_TaskList_From_OriginalRequest (Areq));

      --   for (auto& rId : m_pendingAutoReq[autoKey])
      for R_Id of Int64_Pending_Auto_Req_Matrix.Element (Container => This.Pending_Auto_Req,
                                                         Key       => AutoKey) loop

         --  auto plan = m_routePlans.find (rId);
         --  if (plan != m_routePlans.end ())  -- Valid by construction
         declare
            --  auto taskpair = m_routeTaskPairing.find (rId);
            Plan : constant Pair_Int64_Route_Plan := Int64_Pair_Int64_Route_Plan_Maps.Element (This.Route_Plan,
                                                                                               R_Id);
         begin

            --  if (taskpair != m_routeTaskPairing.end ())
            if Int64_Aggregator_Task_Option_Pair_Maps.Contains (Container => This.Route_Task_Pairing,
                                                                Key       => R_Id)
            then
               declare
                  Task_Pair : constant AggregatorTaskOptionPair := Int64_Aggregator_Task_Option_Pair_Maps.Element (This.Route_Task_Pairing,
                                                                                                                   R_Id);

                  --  auto toc = new uxas::messages::task::TaskOptionCost;
                  Task_Option_Cost : My_TaskOptionCost;
               begin

                  --  if (plan->second.second->getRouteCost () < 0)
                  if Get_RouteCost (Plan.Returned_Route_Plan) < 0
                  then
                     Route_Not_Found := To_Unbounded_String ("V[" & Task_Pair.VehicleId'Image & "](" & Task_Pair.PrevTaskId'Image  &  ","
                                                             & Task_Pair.PrevTaskOption'Image  & ")-(" & Task_Pair.TaskId'Image
                                                             & "," & Task_Pair.TaskOption'Image  & ")");
                  end if;

                  Set_DestinationTaskID (Task_Option_Cost, Task_Pair.TaskId);
                  Set_IntialTaskOption  (Task_Option_Cost, Task_Pair.PrevTaskOption);
                  Set_DestinationTaskOption (Task_Option_Cost, Task_Pair.TaskOption);
                  Set_IntialTaskID (Task_Option_Cost, Task_Pair.PrevTaskId);
                  Set_TimeToGo  (Task_Option_Cost, Get_RouteCost (Plan.Returned_Route_Plan));
                  Set_VehicleID (Task_Option_Cost, Task_Pair.VehicleId);

                  --  matrix->getCostMatrix ().push_back(toc);
                  Add_TaskOptionCost_To_CostMatrix (Matrix, Task_Option_Cost);

                  --  m_routeTaskPairing.erase (taskpair);
                  Int64_Aggregator_Task_Option_Pair_Maps.Delete (This.Route_Task_Pairing,
                                                                 R_Id);
               end;
            end if;
            --  // Clear out Memory
            --  M_RoutePlanResponses.Erase (Plan->Second.First);
            --  M_RoutePlans.Erase (Plan);

            Int64_Route_Plan_Responses_Maps.Delete (This.Route_Plan_Responses,
                                                    Plan.Reponse_ID);
            Int64_Pair_Int64_Route_Plan_Maps.Delete (This.Route_Plan,
                                                     R_Id);
         end;
      end loop;

      --  // Send The Total Cost Matrix
      --  Std::Shared_Ptr<Avtas::Lmcp::Object> PResponse = Std::Static_Pointer_Cast<Avtas::Lmcp::Object>(Matrix);
      --  SendSharedLmcpObjectBroadcastMessage (PResponse);
      My_Send_Shared_LMCP_Object_Broadcast_Message (This,
                                                    Matrix);

      --  // clear out old options
      --  M_TaskOptions.Clear();
      Int64_Task_Plan_Options_Maps.Clear (This.Task_Plan_Options);

      Set_StatusType (Service_Status, Afrl.Cmasi.Enumerations.Information);
      --  if (!routesNotFound.str().empty())
      if Length (Route_Not_Found) > 0 then

         Add_KeyPair (This          => Service_Status,
                      KeyPair_Key   => To_Unbounded_String ("RoutesNotFound - [VehicleId](StartTaskId,StartOptionId)-(EndTaskId,EndOptionId)"),
                      KeyPair_Value => Route_Not_Found);

         Put (To_String ("RoutesNotFound - [VehicleId](StartTaskId,StartOptionId)-(EndTaskId,EndOptionId) :: " & Route_Not_Found));

      else

         Add_KeyPair (This          => Service_Status,
                      KeyPair_Key   => To_Unbounded_String ("AssignmentMatrix - full"));

      end if;

      --  sendSharedLmcpObjectBroadcastMessage (serviceStatus);
      My_Send_LMCP_Object_Broadcast_Message (This, Service_Status);

   end Send_Matrix;

   --------------------------
   -- Check_All_Route_Plans --
   --------------------------

   --  for each request see if all the responce are receve and then send them
   procedure Check_All_Route_Plans (This : in out Route_Aggregator_Service)
   is

      --  TODO : Put Send_matrix here

      --  TODO : Put Send_Route_Response

      C : Int64_Pending_Route_Matrix.Cursor :=
        Int64_Pending_Route_Matrix.First (Container => This.Pending_Route);

      I : Int64_Pending_Auto_Req_Matrix.Cursor :=
        Int64_Pending_Auto_Req_Matrix.First (Container => This.Pending_Auto_Req);

   begin

      --  // check pending route requests
      while Int64_Pending_Route_Matrix.Has_Element (Container => This.Pending_Route,
                                                    Position  => C)
      loop
         declare

            --  i->first ()
            Route_Id : constant Int64 :=
              Int64_Pending_Route_Matrix.Key (Container => This.Pending_Route,
                                              Position  => C);
         begin

            Int64_Pending_Route_Matrix.Next (Container => This.Pending_Route,
                                             Position  => C);
            if All_Route_Response_Receive (This, Route_Id) then

               Send_Route_Reponse (This     => This,
                                   RouteKey => Route_Id);

               Int64_Pending_Route_Matrix.Delete (Container => This.Pending_Route,
                                                  Key       => Route_Id);
            end if;
         end;
      end loop;

      --  // check pending automation requests
      while Int64_Pending_Auto_Req_Matrix.Has_Element (Container => This.Pending_Auto_Req,
                                                       Position  => I)
      loop
         declare

            --  k->first ()
            Req_Id : constant Int64 := Int64_Pending_Auto_Req_Matrix.Key (Container => This.Pending_Auto_Req,
                                                                          Position  => I);

         begin

            Int64_Pending_Auto_Req_Matrix.Next (Container => This.Pending_Auto_Req,
                                                Position  => I);

            if All_Matrix_Response_Receive (This, Req_Id) then

               --  SendMatrix (k->first);
               Send_Matrix (This, Req_Id);

               --  // finished with this automation request, discard
               --  m_uniqueAutomationRequests.erase (k->first);

               Int64_Unique_Automation_Request_Maps.Delete (Container => This.Unique_Automation_Request,
                                                            Key       => Req_Id);

               --  k = m_pendingAutoReq.erase (k);
               Int64_Pending_Auto_Req_Matrix.Delete (Container => This.Pending_Auto_Req,
                                                     Key       => Req_Id);

            end if;
         end;

      end loop;

   end Check_All_Route_Plans;

   ------------------------------------
   -- Check_All_Task_Option_Received --
   ------------------------------------

   --  verify if all the Task infomation relatif to a Unique Automation Request are received
   procedure Check_All_Task_Option_Received (This : in out Route_Aggregator_Service)
   is

      --  TODO : Put Build_Matrix_Requests here

      C : Int64_Unique_Automation_Request_Maps.Cursor := Int64_Unique_Automation_Request_Maps.First (Container => This.Unique_Automation_Request);

   begin
      while Int64_Unique_Automation_Request_Maps.Has_Element (Container => This.Unique_Automation_Request,
                                                              Position  => C) loop

         declare

            --  areqIter->second
            Request : constant My_UniqueAutomationRequest :=
              Int64_Unique_Automation_Request_Maps.Element (Container => This.Unique_Automation_Request,
                                                            Position  => C).Content;

            --  areqIter->first
            Index_Request : constant Int64 := Int64_Unique_Automation_Request_Maps.Key (Container => This.Unique_Automation_Request,
                                                                                        Position  => C);

         begin

            if All_Task_Option_Receive (This, Request) then

               --  BuildMatrixRequests (areqIter->first, areqIter->second);
               Build_Matrix_Requests (This  => This,
                                      ReqID => Index_Request,
                                      Areq  => Request);
            end if;
         end;

         Int64_Unique_Automation_Request_Maps.Next (Container => This.Unique_Automation_Request,
                                                    Position  => C);
      end loop;
   end Check_All_Task_Option_Received;

   --------------------
   -- Euclidean_Plan --
   --------------------

   use all type Vect_My_RouteConstraints;
   --  procces to the calculation of one Reoute Plan request
   procedure Euclidean_Plan (This               : in out Route_Aggregator_Service;
                             Route_Plan_Request : My_RoutePlanRequest) with

     Pre =>  -- the calculation was never done before
       (not Contains (This.Route_Plan_Responses, Get_RequestID (Route_Plan_Request)))
     -- none of the sub route calculation were not done
     and (for all Ind in First_Index (Get_RouteRequests (Route_Plan_Request)) ..  Last_Index (Get_RouteRequests (Route_Plan_Request))
          => not Contains (This.Route_Plan,
                           Get_RouteID (Element (Get_RouteRequests (Route_Plan_Request),
                                                 Ind))))
     -- check the fact that the request don't come from nowhere
     and Contains (This.Pending_Route,
                   Get_RequestID (Route_Plan_Request))

       -- Check The Index unicity of sub calculation
     and (for all Ind_1 in First_Index (Get_RouteRequests (Route_Plan_Request)) .. Last_Index (Get_RouteRequests (Route_Plan_Request))
          => (for all Ind_2 in Ind_1 + 1 .. Last_Index (Get_RouteRequests (Route_Plan_Request))
              => (Get_RouteID (Element (Get_RouteRequests (Route_Plan_Request), Ind_1)) /=
                    Get_RouteID (Element (Get_RouteRequests (Route_Plan_Request), Ind_2)))))

     -- invariant check
     and All_Requests_Valid (This)

     -- check no overflow on insertion
     and Length (This.Route_Plan_Responses) < This.Route_Plan_Responses.Capacity
     and Length (This.Route_Plan) + Length (Get_RouteRequests (Route_Plan_Request)) <= This.Route_Plan.Capacity

   --  check it is call is legit
     and This.Fast_Plan
     and Contains (This.Ground_Vehicles, Get_VehicleID (Route_Plan_Request)),

     Post => All_Requests_Valid (This)

     and Contains (This.Route_Plan_Responses,
                   Get_RequestID (Route_Plan_Request))

     and  (for all I in First_Index (Get_RouteRequests (Route_Plan_Request)) ..  Last_Index (Get_RouteRequests (Route_Plan_Request))
           => Contains (This.Route_Plan, Get_RouteID (Element (Get_RouteRequests (Route_Plan_Request), I))));

   --   TODO : add property on data conscervation;

   procedure Euclidean_Plan (This             : in out Route_Aggregator_Service;
                             Route_Plan_Request : My_RoutePlanRequest)

   is
      use Vect_My_RouteConstraints_P;

      Region_ID   : constant Int64 := Get_OperatingRegion  (Route_Plan_Request);
      Vehicles_ID : constant Int64 := Get_VehicleID        (Route_Plan_Request);
      Task_ID     : constant Int64 := Get_AssociatedTaskID (Route_Plan_Request);
      Request_ID  : constant Int64 := Get_RequestID        (Route_Plan_Request);

      Speed  : Long_Float := 1.0; -- default if no speed available

      --  auto response = std::shared_ptr<uxas::messages::route::RoutePlanResponse>(new uxas::messages::route::RoutePlanResponse);
      Response : My_RoutePlanResponse;
   begin
      --  recup the vehicle speed
      if Int64_Entity_Configuration_Maps.Contains (Container => This.Entity_Configuration,
                                                   Key       => Vehicles_ID)
      then

         --   double speed = m_entityConfigurations[vehicleId]->getNominalSpeed ();
         Speed := Long_Float (Get_NominalSpeed (Int64_Entity_Configuration_Maps.Element (Container => This.Entity_Configuration,
                                                                                         Key       => Vehicles_ID).Content));

         --  if (speed < 1e-2)
         if Speed < 0.02 then
            Speed := 1.0; --  default to 1 if too small for division
         end if;
      end if;
      pragma Assert (Speed > 0.02);

      Set_AssociatedTaskID (Response, Task_ID);
      Set_OperatingRegion  (Response, Region_ID);
      Set_VehicleID        (Response, Vehicles_ID);
      Set_ResponseID       (Response, Request_ID);
      pragma Assert (Get_ResponseID (Response) = Request_ID);
      pragma Assert (Check_Route_Plan_Response (This.Route_Plan_Responses));
      pragma Assert (All_Requests_Valid (This));

      declare
         RoutePlanResponses_Holder     : constant Route_Plan_Responses_Holder := Route_Plan_Responses_Holder'(Content => Response);
         This_Route_Plan_Responses_Old : constant Route_Plan_Responses_Map := This.Route_Plan_Responses with Ghost;
      begin

         pragma Assert (if All_Requests_Valid (This) then
                           Check_Route_Plan (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses));
         pragma Assert (for all C in This.Route_Plan
                        => Get_RouteID (Element (This.Route_Plan, C).Returned_Route_Plan) = Key (This.Route_Plan, C)
                        and Contains (This.Pending_Route,        Element (This.Route_Plan, C).Reponse_ID)
                        and Contains (This.Route_Plan_Responses, Element (This.Route_Plan, C).Reponse_ID));
         pragma Assert (for all C in This.Route_Plan_Responses
                        =>  Check_Route_Plan_Response_Sub (Element (This.Route_Plan_Responses, C).Content, Key (This.Route_Plan_Responses, C)));
         pragma Assert (for all Key in Int64
                        => (if Contains (This.Route_Plan_Responses, Key) then
                               Int64_Route_Plan_Responses_Maps.Key (This.Route_Plan_Responses, Find (This.Route_Plan_Responses, Key)) = Key
                            and Get_ResponseID (Element  (This.Route_Plan_Responses, Find (This.Route_Plan_Responses, Key)).Content) =  Key
                            and Check_Route_Plan_Response_Sub (Route_Plan_Response => Element (This.Route_Plan_Responses,
                                                               Key                 => Find (This.Route_Plan_Responses, Key)).Content,  Key)));
         pragma Assert (Length (This.Route_Plan_Responses) < This.Route_Plan_Responses.Capacity);

         --  Create a route plan response for the routePlan request ID
         Int64_Route_Plan_Responses_Maps.Insert
           (Container => This.Route_Plan_Responses,
            Key       => Get_ResponseID (RoutePlanResponses_Holder.Content),
            New_Item  => RoutePlanResponses_Holder);

         pragma Assert (Contains (This.Route_Plan_Responses, Get_ResponseID (RoutePlanResponses_Holder.Content))
                        and then Check_Route_Plan_Response_Sub
                          (Route_Plan_Response => Element (Container => This.Route_Plan_Responses,
                                                           Index     => Get_ResponseID (RoutePlanResponses_Holder.Content)).Content,
                           Key                 =>  Get_ResponseID (RoutePlanResponses_Holder.Content)));

         Lemma_Ceck_Route_Plan_Reference_Insert (This.Route_Plan,
                                                 This.Pending_Route, This.Pending_Route,
                                                 This_Route_Plan_Responses_Old, This.Route_Plan_Responses);

         pragma Assert (Check_Route_Plan (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses));

         pragma Assert (if  Check_Route_Plan_Response   (This.Route_Plan_Responses)
                        then All_Requests_Valid (This));
         pragma Assert (Contains (This.Route_Plan_Responses, Get_ResponseID (Response)));
         pragma Assert (Model (This_Route_Plan_Responses_Old) <= Model (This.Route_Plan_Responses));
         pragma Assert (Int64_Route_Plan_Responses_Maps.Formal_Model.M.Keys_Included_Except (Model (This.Route_Plan_Responses),
                        Model (This_Route_Plan_Responses_Old),
                        Get_ResponseID (Response)));
         pragma Assert (for all Key in Int64
                        => (if Contains (This_Route_Plan_Responses_Old, Key) then
                               Contains (This.Route_Plan_Responses,     Key)));
         pragma Assert (for all C in This.Route_Plan
                        => Contains (This_Route_Plan_Responses_Old, Element (This.Route_Plan, C).Reponse_ID)
                        and Contains (This.Route_Plan_Responses,    Element (This.Route_Plan, C).Reponse_ID));

         pragma Assert (for all Key of Model (This_Route_Plan_Responses_Old)
                        =>  (Contains (This.Route_Plan_Responses, Key)
                             and Contains (This_Route_Plan_Responses_Old, Key)
                             and Int64_Route_Plan_Responses_Maps.Formal_Model.M.Has_Key (Model (This.Route_Plan_Responses), Key))
                        and then
                          (Int64_Route_Plan_Responses_Maps.Formal_Model.M.Get (Model (This.Route_Plan_Responses), Key) =
                             Int64_Route_Plan_Responses_Maps.Formal_Model.M.Get (Model (This_Route_Plan_Responses_Old), Key)
                           and (if Int64_Route_Plan_Responses_Maps.Formal_Model.M.Get (Model (This.Route_Plan_Responses), Key) =
                                 Int64_Route_Plan_Responses_Maps.Formal_Model.M.Get (Model (This_Route_Plan_Responses_Old), Key) then
                                Element (This.Route_Plan_Responses,  Key) = Element (This_Route_Plan_Responses_Old,  Key))
                           and (if  Element (This.Route_Plan_Responses,  Key) = Element (This_Route_Plan_Responses_Old,  Key) then
                                Element (This.Route_Plan_Responses,  Key).Content = Element (This_Route_Plan_Responses_Old,  Key).Content)
                           and (if Element (This.Route_Plan_Responses,  Key).Content = Element (This_Route_Plan_Responses_Old,  Key).Content then
                                Get_ResponseID (Element (This.Route_Plan_Responses,  Key).Content)
                             = Get_ResponseID (Element (This_Route_Plan_Responses_Old,  Key).Content))

                           and (if   Get_ResponseID (Element (This.Route_Plan_Responses,  Key).Content)
                             = Get_ResponseID (Element (This_Route_Plan_Responses_Old,  Key).Content)
                             and Get_ResponseID (Element  (This_Route_Plan_Responses_Old, Key).Content) =  Key then
                                Get_ResponseID (Element  (This.Route_Plan_Responses, Key).Content) =  Key)
                           and (if   Get_ResponseID (Element  (This.Route_Plan_Responses, Key).Content) =  Key then
                                  Check_Route_Plan_Response_Sub (Element  (This.Route_Plan_Responses, Key).Content, Key))
                           and Check_Route_Plan_Response_Sub (Element (This_Route_Plan_Responses_Old, Key).Content, Key)));
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
                                       Key       => Get_RouteID (Element (Get_RouteRequests (Route_Plan_Request), Ind)))));
      declare
         Length_This_Route_Plan_Old : constant Count_Type := Length (This.Route_Plan) with Ghost;
         Acc : Count_Type := 0 with Ghost;
      begin
         pragma Assert (Length (This.Route_Plan)   + Length (Get_RouteRequests (Route_Plan_Request)) <= This.Route_Plan.Capacity);
         pragma Assert (Length_This_Route_Plan_Old + Length (Get_RouteRequests (Route_Plan_Request)) <= This.Route_Plan.Capacity);
         --  for (size_t k = 0; k < request->getRouteRequests ().size (); k++)

         --  For each ROute requet contain by the the Route Plan
         --  create a Plan, made the calculation and and it to Route_Plan

         for K in First_Index (Get_RouteRequests (Route_Plan_Request)) .. Last_Index (Get_RouteRequests (Route_Plan_Request)) loop

            pragma Loop_Invariant ((for all I in First_Index (Get_RouteRequests (Route_Plan_Request))
                                   .. Last_Index (Get_RouteRequests (Route_Plan_Request))
                                   => (if I < K then
                                          Contains (Container => This.Route_Plan,
                                                    Key       => Get_RouteID (Element (Container => Get_RouteRequests (Route_Plan_Request),
                                                                                       Index     => I)))
                                       else
                                         not Contains (Container => This.Route_Plan,
                                                       Key       => Get_RouteID (Element (Container => Get_RouteRequests (Route_Plan_Request),
                                                                                          Index     => I)))))
                                   and Check_Route_Plan (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses)
                                   and All_Requests_Valid (This)
                                   and Contains (This.Pending_Route,         Request_ID)
                                   and Contains (This.Route_Plan_Responses,  Request_ID)
                                   and Length_This_Route_Plan_Old + Acc = Length (This.Route_Plan)
                                   and Acc <=  Length (Get_RouteRequests (Route_Plan_Request))
                                   and Integer (Acc) = K - First_Index (Get_RouteRequests (Route_Plan_Request)));
            declare

               Route_Request : constant My_RouteConstraints := Element (Container => Get_RouteRequests (Route_Plan_Request),
                                                                        Index  => K);

               Route_ID : constant Int64 := Get_RouteID (Route_Request);
               pragma Assert (Route_ID =  Get_RouteID (Element (Container => Get_RouteRequests (Route_Plan_Request),
                                                                Index     => K)));

               Plan : My_RoutePlan;
            begin
               declare

                  use Convert;

                  Borne_Min : constant Long_Float := 0.0;
                  Borne_Max : constant Long_Float := 6_000_000_000_000.0;
                  subtype Borne_Travel_Time is Long_Float range Borne_Min .. Borne_Max;

                  Line_Dist : Linear_Distance_M;

                  function To_Latitude (Latitude : Real64) return RAD_Latitude
                  is (DEG_Angle_To_Latitude_Projection (Normalize_Angle_DEG (Long_Float (Latitude))));

               begin
                  Set_RouteID (Plan, Route_ID);

                  Get_Linear_Distance_M_Lat1_Long1_DEG_To_Lat2_Long2_DEG
                    (Latitude_1_DEG  => To_Latitude (Get_Latitude  (Get_StartLocation (Route_Request))),
                     Longitude_1_DEG => Normalize_Angle_DEG (Long_Float  (Get_Longitude (Get_StartLocation (Route_Request)))),
                     Latitude_2_DEG  => To_Latitude (Get_Latitude  (Get_EndLocation  (Route_Request))),
                     Longitude_2_DEG => Normalize_Angle_DEG (Long_Float  (Get_Longitude (Get_EndLocation  (Route_Request)))),
                     Linear_Distance => Line_Dist);

                  pragma Assert (Speed > 0.02);
                  declare

                     Travel_Time : constant Borne_Travel_Time := (Line_Dist / Speed) * 1000.0;

                     pragma Assert (Travel_Time in Borne_Min .. Borne_Max);

                     pragma Assert (Int64 (Borne_Min) in Int64'Range);
                     pragma Assert (Int64 (Borne_Max) in Int64'Range);

                     pragma Assert (Long_Float (Int64'First) < Travel_Time);
                     pragma Assert (Long_Float (Int64'Last)  > Travel_Time);

                     Route_Cost : constant Int64 := Int64 (Travel_Time);

                  begin
                     Set_RouteCost (Plan, Route_Cost);
                  end;
               end;

               declare
                  Route_Plan_Pair : constant Pair_Int64_Route_Plan := Pair_Int64_Route_Plan'(Reponse_ID          => Request_ID,
                                                                                             Returned_Route_Plan => Plan);
                  Position_Route_Plan : Int64_Pair_Int64_Route_Plan_Maps.Cursor;
                  This_Route_Plan_Old : constant Pair_Int64_Route_Plan_Map := This.Route_Plan with Ghost;
                  use Int64_Pair_Int64_Route_Plan_Maps.Formal_Model;
               begin

                  pragma Assert (Route_Plan_Pair.Reponse_ID = Request_ID);
                  pragma Assert (Contains (This.Pending_Route,        Route_Plan_Pair.Reponse_ID));
                  pragma Assert (Contains (This.Route_Plan_Responses, Route_Plan_Pair.Reponse_ID));

                  pragma Assert (Check_Route_Plan (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses));
                  pragma Assert (for all C in This.Route_Plan
                                 => Get_RouteID (Element (This.Route_Plan, C).Returned_Route_Plan) = Key (This.Route_Plan, C)
                                 and Contains (This.Pending_Route,        Element (This.Route_Plan, C).Reponse_ID)
                                 and Contains (This.Route_Plan_Responses, Element (This.Route_Plan, C).Reponse_ID));
                  pragma Assert (for all Key in Int64
                                 => (if Contains (This.Route_Plan, Key) then
                                        Int64_Pair_Int64_Route_Plan_Maps.Key (This.Route_Plan, Find (This.Route_Plan, Key)) = Key
                                     and Get_RouteID (Element (This.Route_Plan,  Find (This.Route_Plan, Key)).Returned_Route_Plan) = Key
                                     and Contains (This.Pending_Route,        Element (This.Route_Plan,  Find (This.Route_Plan, Key)).Reponse_ID)
                                     and Contains (This.Route_Plan_Responses, Element (This.Route_Plan,  Find (This.Route_Plan, Key)).Reponse_ID)
                                     and Check_Route_Plan_Sub (Route_Plan_Pair      => Element (This.Route_Plan,  Find (This.Route_Plan, Key)),
                                                               Pending_Route        => This.Pending_Route,
                                                               Route_Plan_Responses => This.Route_Plan_Responses,
                                                               Key                  => Key)));

                  pragma Assert (for all Key of Model (This.Route_Plan)
                                 => Check_Route_Plan_Sub (Element (This.Route_Plan, Key), This.Pending_Route, This.Route_Plan_Responses, Key));

                  Int64_Pair_Int64_Route_Plan_Maps.Insert
                    (Container => This.Route_Plan,
                     Key       => Get_RouteID (Route_Plan_Pair.Returned_Route_Plan),
                     New_Item  => Route_Plan_Pair);

                  Position_Route_Plan := Find (Container => This.Route_Plan,
                                               Key       => Get_RouteID (Route_Plan_Pair.Returned_Route_Plan));
                  Acc := Acc + 1;
                  pragma Assert (Length (This.Route_Plan) = Length (This_Route_Plan_Old) + 1);
                  pragma Assert (Length_This_Route_Plan_Old + Acc = Length (This.Route_Plan));

                  Lemmma_Equal_RoutePlan (Element (This.Route_Plan, Position_Route_Plan).Returned_Route_Plan, Route_Plan_Pair.Returned_Route_Plan);
                  pragma Assert (Has_Element (This.Route_Plan, Position_Route_Plan)
                                 and Key (This.Route_Plan, Position_Route_Plan) = Get_RouteID (Route_Plan_Pair.Returned_Route_Plan)
                                 and Key (This.Route_Plan, Position_Route_Plan) 
                                 = Get_RouteID (Element (This.Route_Plan, Position_Route_Plan).Returned_Route_Plan)
                                 and Contains (This.Pending_Route,        Element (This.Route_Plan, Position_Route_Plan).Reponse_ID)
                                 and Contains (This.Route_Plan_Responses, Element (This.Route_Plan, Position_Route_Plan).Reponse_ID));
                  pragma Assert (Contains (This.Route_Plan, Get_RouteID (Route_Plan_Pair.Returned_Route_Plan)));
                  pragma Assert (Check_Route_Plan_Sub (Route_Plan_Pair      => Element (This.Route_Plan, Position_Route_Plan),
                                                       Pending_Route        => This.Pending_Route,
                                                       Route_Plan_Responses =>  This.Route_Plan_Responses,
                                                       Key                  => Key (This.Route_Plan, Position_Route_Plan)));
                  --                    pragma Assert (for all C in This.Route_Plan
                  --                                   =>  Contains (This.Pending_Route,        Element (This.Route_Plan, C).Reponse_ID)
                  --                                   and Contains (This.Route_Plan_Responses, Element (This.Route_Plan, C).Reponse_ID));
                  pragma Assert (if (for all Cursor in This.Route_Plan
                                 => Check_Route_Plan_Sub (Route_Plan_Pair      => Element (This.Route_Plan, Cursor),
                                                          Pending_Route        => This.Pending_Route,
                                                          Route_Plan_Responses => This.Route_Plan_Responses,
                                                          Key                  => Key (This.Route_Plan, Cursor)))
                                 then Check_Route_Plan   (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses));
                  pragma Assert (if Check_Route_Plan   (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses)
                                 then  All_Requests_Valid (This));

                  pragma Assert (Check_Entity_State  (This.Entity_State, This.Air_Vehicules, This.Ground_Vehicles, This.Surface_Vehicles));
                  pragma Assert (Check_Pending_Route (This.Pending_Route, This.Route_Id));
                  pragma Assert (Check_Task_Plan_Options    (This.Task_Plan_Options));
                  pragma Assert (Check_Route_Task_Pairing   (This.Route_Task_Pairing, This.Entity_State, This.Route_Request_ID));
                  pragma Assert (Check_Route_Plan_Response  (This.Route_Plan_Responses));
                  pragma Assert (Check_Entity_Configuration (Entity_Configuration => This.Entity_Configuration,
                                                             Air_Vehicules        => This.Air_Vehicules,
                                                             Ground_Vehicles      => This.Ground_Vehicles,
                                                             Surface_Vehicles     => This.Surface_Vehicles));
                  pragma Assert (Check_List_Pending_Request (Pending_Auto_Req          => This.Pending_Auto_Req,
                                                             Unique_Automation_Request => This.Unique_Automation_Request,
                                                             Route_Task_Pairing        => This.Route_Task_Pairing,
                                                             Route_Request_ID          => This.Route_Request_ID));
                  pragma Assert (Check_Unique_Automation_Request (This.Unique_Automation_Request, This.Auto_Request_Id));

                  pragma Assert (Model (This_Route_Plan_Old) <= Model (This.Route_Plan));
                  pragma Assert (Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Keys_Included_Except (Model (This.Route_Plan),
                                 Model (This_Route_Plan_Old),
                                 Get_RouteID (Route_Plan_Pair.Returned_Route_Plan)));
                  pragma Assert (Check_Route_Plan   (This_Route_Plan_Old, This.Pending_Route, This.Route_Plan_Responses));
                  pragma Assert  (for all Key of Model (This_Route_Plan_Old)
                                  =>  (Contains (This.Route_Plan, Key)
                                       and Contains (This_Route_Plan_Old, Key)
                                       and Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Has_Key (Model (This.Route_Plan), Key))
                                  and then
                                    (Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Get (Model (This.Route_Plan), Key) =
                                       Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Get (Model (This_Route_Plan_Old), Key)
                                     and (if Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Get (Model (This.Route_Plan), Key) =
                                           Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Get (Model (This_Route_Plan_Old), Key) then
                                          Element (This.Route_Plan,  Key) = Element (This_Route_Plan_Old,  Key))
                                     and (if  Element (This.Route_Plan,  Key) = Element (This_Route_Plan_Old,  Key) then
                                          Element (This.Route_Plan,  Key).Reponse_ID = Element (This_Route_Plan_Old,  Key).Reponse_ID
                                       and Element (This.Route_Plan,  Key).Returned_Route_Plan
                                       = Element (This_Route_Plan_Old,  Key).Returned_Route_Plan)
                                     and (if  Element (This.Route_Plan,  Key).Returned_Route_Plan
                                       = Element (This_Route_Plan_Old,  Key).Returned_Route_Plan then
                                          Same_Requests (Element (This.Route_Plan,  Key).Returned_Route_Plan,
                                         Element (This_Route_Plan_Old,  Key).Returned_Route_Plan))
                                     and (if Same_Requests (Element (This.Route_Plan,  Key).Returned_Route_Plan,
                                       Element (This_Route_Plan_Old,  Key).Returned_Route_Plan) then
                                            Get_RouteID (Element (This.Route_Plan,  Key).Returned_Route_Plan)
                                       = Get_RouteID (Element (This_Route_Plan_Old,  Key).Returned_Route_Plan))
                                     and Check_Route_Plan_Sub (Element (This_Route_Plan_Old, Key), This.Pending_Route, This.Route_Plan_Responses, Key)
                                     and (if Check_Route_Plan_Sub (Route_Plan_Pair      => Element (This_Route_Plan_Old, Key),
                                                                   Pending_Route        => This.Pending_Route,
                                                                   Route_Plan_Responses => This.Route_Plan_Responses,
                                                                   Key                  => Key)
                                       then
                                          Get_RouteID (Element  (This_Route_Plan_Old, Key).Returned_Route_Plan) =  Key
                                       and Contains (This.Pending_Route,        Element (This_Route_Plan_Old, Key).Reponse_ID)
                                       and Contains (This.Route_Plan_Responses, Element (This_Route_Plan_Old, Key).Reponse_ID))

                                     and (if Contains (This.Pending_Route,        Element (This_Route_Plan_Old, Key).Reponse_ID)
                                       and Contains (This.Route_Plan_Responses, Element (This_Route_Plan_Old, Key).Reponse_ID)
                                       and Element (This.Route_Plan,  Key).Reponse_ID = Element (This_Route_Plan_Old,  Key).Reponse_ID
                                       then Contains (This.Pending_Route,        Element (This.Route_Plan, Key).Reponse_ID)
                                       and Contains (This.Route_Plan_Responses, Element (This.Route_Plan, Key).Reponse_ID))

                                     and (if  Get_RouteID (Element  (This_Route_Plan_Old, Key).Returned_Route_Plan)
                                       =  Get_RouteID (Element  (This.Route_Plan, Key).Returned_Route_Plan)
                                       and Get_RouteID (Element  (This_Route_Plan_Old, Key).Returned_Route_Plan) =  Key then
                                          Get_RouteID (Element  (This.Route_Plan, Key).Returned_Route_Plan) =  Key)

                                     and (if Element (This.Route_Plan,  Key).Reponse_ID = Element (This_Route_Plan_Old,  Key).Reponse_ID
                                       and Contains (This.Pending_Route,        Element (This_Route_Plan_Old, Key).Reponse_ID)
                                       and Contains (This.Route_Plan_Responses, Element (This_Route_Plan_Old, Key).Reponse_ID) then
                                          Contains (This.Pending_Route,        Element  (This.Route_Plan,    Key).Reponse_ID)
                                       and Contains (This.Route_Plan_Responses, Element  (This.Route_Plan,    Key).Reponse_ID))

                                     and (if Get_RouteID (Element  (This.Route_Plan, Key).Returned_Route_Plan) =  Key
                                       and Contains (This.Pending_Route,        Element (This.Route_Plan, Key).Reponse_ID)
                                       and Contains (This.Route_Plan_Responses, Element (This.Route_Plan, Key).Reponse_ID)
                                       then Check_Route_Plan_Sub (Element (This.Route_Plan, Key), This.Pending_Route, This.Route_Plan_Responses, Key)
                                       and  Check_Route_Plan_Sub (Route_Plan_Pair      => Element (This_Route_Plan_Old, Key),
                                                                  Pending_Route        => This.Pending_Route,
                                                                  Route_Plan_Responses => This.Route_Plan_Responses,
                                                                  Key                  => Key))));

                  pragma Assert  (for all C in This.Route_Plan
                                  => (if  Key (This.Route_Plan, C) = Get_RouteID (Route_Plan_Pair.Returned_Route_Plan)
                                      then
                                         Check_Route_Plan_Sub (Route_Plan_Pair      => Element  (This.Route_Plan, Key (This.Route_Plan, C)),
                                                               Pending_Route        => This.Pending_Route,
                                                               Route_Plan_Responses => This.Route_Plan_Responses,
                                                               Key                  => Key (This.Route_Plan, C))
                                      else
                                         Check_Route_Plan_Sub (Route_Plan_Pair      => Element  (This.Route_Plan, Key (This.Route_Plan, C)),
                                                               Pending_Route        => This.Pending_Route,
                                                               Route_Plan_Responses => This.Route_Plan_Responses,
                                                               Key                  => Key (This.Route_Plan, C))));

                  pragma Assert  (for all Cursor in This.Route_Plan
                                  => Check_Route_Plan_Sub (Route_Plan_Pair      => Element (This.Route_Plan, Cursor),
                                                           Pending_Route        => This.Pending_Route,
                                                           Route_Plan_Responses => This.Route_Plan_Responses,
                                                           Key                  => Key (This.Route_Plan, Cursor)));
                  pragma Assert  (if (for all Cursor in This.Route_Plan
                                  => Check_Route_Plan_Sub (Route_Plan_Pair      => Element (This.Route_Plan, Cursor),
                                                           Pending_Route        => This.Pending_Route,
                                                           Route_Plan_Responses => This.Route_Plan_Responses,
                                                           Key                  => Key (This.Route_Plan, Cursor)))
                                  then Check_Route_Plan     (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses));
                  pragma Assert  (if Check_Route_Plan   (This.Route_Plan, This.Pending_Route, This.Route_Plan_Responses)
                                  then  All_Requests_Valid (This));

               end;
               pragma Assert (All_Requests_Valid (This));

            end;

            --  loop invariant
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
      end;

   end Euclidean_Plan;

   --------------------------
   -- Handle_Route_Request --
   --------------------------

   --  create a croresponding RouteRequest for each elligibles vehicle
   --  then send them for calculation
   procedure Handle_Route_Request
     (This          : in out Route_Aggregator_Service;
      Route_Request : My_RouteRequest)
   is
      use Int64_Vects;
      use Int64_Entity_State_Maps;

      --  TODO : Put Euclidean_Plan Here

      procedure My_Send_LMCP_Object_Limited_Cast_Message
        (This : in out Route_Aggregator_Service;
         CastAddress : String;
         Request : My_RoutePlanRequest);

      procedure My_Send_LMCP_Object_Limited_Cast_Message
        (This : in out Route_Aggregator_Service;
         CastAddress : String;
         Request : My_RoutePlanRequest) with
        SPARK_Mode => Off

      is
         Request_Acc : constant RoutePlanRequest_Acc := new RoutePlanRequest;
      begin
         Request_Acc.all := Unwrap (Request);
         This.Send_LMCP_Object_Limited_Cast_Message (CastAddress => CastAddress,
                                                     Msg         => Object_Any (Request_Acc));
      end My_Send_LMCP_Object_Limited_Cast_Message;

      Vect_VehiclesID : Int64_Vect := Get_VehicleID (Route_Request);

   begin

      --  if the list of eligible vehicles is empty that mean they are all eligible
      if Is_Empty (Vect_VehiclesID) then

         for State_Cursor in This.Entity_State loop
            Append (Vect_VehiclesID,
                    Get_ID (Int64_Entity_State_Maps.Element (Container => This.Entity_State,
                                                             Position  => State_Cursor).Content));
         end loop;

      end if;

      --  create the RoutePlanRequest for evry eligible vehicles
      for Id_Indx in First_Index (Vect_VehiclesID) .. Last_Index (Vect_VehiclesID)  loop

         declare

            Vehicles_Id : constant Int64 := Element (Container => Vect_VehiclesID,
                                                     Index     => Id_Indx);

            --  std::shared_ptr<uxas::messages::route::RoutePlanRequest> planRequest (new uxas::messages::route::RoutePlanRequest);
            Plan_Request : My_RoutePlanRequest;

            List_Of_Request : Int64_Set := Element (Container => This.Pending_Route,
                                                    Key       => Get_RequestID (Route_Request));

            use Vect_My_RouteConstraints_P;
         begin

            --  create a plan for this vehicles
            Set_AssociatedTaskID  (Plan_Request, Get_AssociatedTaskID  (Route_Request));
            Set_IsCostOnlyRequest (Plan_Request, Get_IsCostOnlyRequest (Route_Request));
            Set_OperatingRegion   (Plan_Request, Get_OperatingRegion   (Route_Request));
            Set_VehicleID         (Plan_Request, Vehicles_Id);
            Set_RequestID         (Plan_Request, This.Route_Request_ID);

            --  m_pendingRoute[request->getRequestID ()].insert (m_routeRequestId);
            Insert (List_Of_Request, This.Route_Request_ID);
            Int64_Pending_Route_Matrix.Replace (Container => This.Pending_Route,
                                                Key       => Get_RequestID (Route_Request),
                                                New_Item  => List_Of_Request);

            --  m_routeRequestId++;
            This.Route_Request_ID := This.Route_Request_ID + 1;

            --  add route request to the RoutePlan
            for Indx in First_Index (Get_RouteRequests (Route_Request)) .. Last_Index (Get_RouteRequests (Route_Request))  loop
               --  planRequest->getRouteRequests ().push_back(r->clone ());
               Append_RouteRequests (This          => Plan_Request,
                                     RouteRequests => Element (Container => Get_RouteRequests (Route_Request),
                                                               Index     => Indx));
            end loop;

            --  start calculation of the RoutePlan
            if Int64_Sets.Contains (Container => This.Ground_Vehicles,
                                    Item      => Vehicles_Id)
            then

               --  if it is a ground vehicles and fast plan is true
               --  the service made the calculation himself
               if This.Fast_Plan then
                  --  // short-circuit and just plan with straight line planner
                  Euclidean_Plan (This               => This,
                                  Route_Plan_Request => Plan_Request);

               else

                  --  // send externally
                  My_Send_LMCP_Object_Limited_Cast_Message (This,
                                                            GroundPathPlanner,
                                                            Plan_Request);

               end if;
            else

               --  // send to aircraft planner
               My_Send_LMCP_Object_Limited_Cast_Message (This,
                                                         AircraftPathPlanner,
                                                         Plan_Request);
            end if;
         end;

      end loop;

      --  if fast planning, then all routes could be complete;
      if This.Fast_Plan then
         Check_All_Route_Plans (This);
      end if;

   end Handle_Route_Request;

end uxas.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK;
