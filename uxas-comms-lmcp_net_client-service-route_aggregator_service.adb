

with avtas.lmcp.object.SPARK_Boundary;              use avtas.lmcp.object.SPARK_Boundary;

with afrl.cmasi.AutomationResponse;                 use afrl.cmasi.AutomationResponse;
with afrl.cmasi.AutomationRequest;                  use afrl.cmasi.AutomationRequest;
with afrl.cmasi.lmcpTask;                           use afrl.cmasi.lmcpTask;
with afrl.cmasi.KeepInZone;                         use afrl.cmasi.KeepInZone;
with afrl.cmasi.KeepOutZone;                        use afrl.cmasi.KeepOutZone;
with afrl.cmasi.RemoveTasks;                        use afrl.cmasi.RemoveTasks;
with afrl.cmasi.ServiceStatus;                      use afrl.cmasi.ServiceStatus;
with afrl.cmasi.KeyValuePair;                       use afrl.cmasi.KeyValuePair;
with afrl.cmasi.OperatingRegion;                    use afrl.cmasi.OperatingRegion;
with afrl.cmasi.AirVehicleConfiguration;            use afrl.cmasi.AirVehicleConfiguration;
with afrl.cmasi.AirVehicleState;                    use afrl.cmasi.AirVehicleState;

with afrl.impact.ImpactAutomationRequest;           use afrl.impact.ImpactAutomationRequest;
with afrl.impact.PointOfInterest;                   use afrl.impact.PointOfInterest;
with afrl.impact.LineOfInterest;                    use afrl.impact.LineOfInterest;
with afrl.impact.AreaOfInterest;                    use afrl.impact.AreaOfInterest;
with afrl.impact.ImpactAutomationResponse;          use afrl.impact.ImpactAutomationResponse;

with afrl.vehicles.SurfaceVehicleConfiguration;     use afrl.vehicles.SurfaceVehicleConfiguration;
with afrl.vehicles.SurfaceVehicleState;             use afrl.vehicles.SurfaceVehicleState;
with afrl.vehicles.GroundVehicleConfiguration;      use afrl.vehicles.GroundVehicleConfiguration;
with afrl.vehicles.GroundVehicleState;              use afrl.vehicles.GroundVehicleState;

with avtas.lmcp.object;                             use avtas.lmcp.object;

with uxas.messages.lmcptask.TaskAutomationRequest;  use uxas.messages.lmcptask.TaskAutomationRequest;
with uxas.messages.lmcptask.TaskAutomationResponse; use uxas.messages.lmcptask.TaskAutomationResponse;
with uxas.messages.lmcptask.TaskInitialized;        use uxas.messages.lmcptask.TaskInitialized;
with uxas.messages.lmcptask.PlanningState;          use uxas.messages.lmcptask.PlanningState;
with uxas.messages.lmcptask.TaskOption;             use uxas.messages.lmcptask.TaskOption;
with uxas.messages.route.object;                    use uxas.messages.route.object;
with uxas.messages.route.RouteConstraints;          use uxas.messages.route.RouteConstraints;

with uxas.Common.Utilities.Unit_Conversions;        use  uxas.Common.Utilities.Unit_Conversions;

with DOM.Core.Elements; use DOM.Core.Elements;
with String_Utils; use String_Utils;

with uxas.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK;
with Ada.Streams;
with uxas.messages.route.RouteRequest;
use uxas.messages.route.RouteRequest;
with uxas.messages.lmcptask.TaskPlanOptions; use uxas.messages.lmcptask.TaskPlanOptions;
with uxas.messages.route.RouteRequest.SPARK_Boundary;

package body uxas.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service is

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Route_Plan_Response_Msg
     (This : in out Route_Aggregator_Service;
      Msg  : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Air_Vehicule_State_Msg
     (This : in out Route_Aggregator_Service;
      Msg  : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Ground_Vehicles_State_Msg
     (This : in out Route_Aggregator_Service;
      Msg  : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Surface_Vehicle_State_Msg
     (This : in out Route_Aggregator_Service;
      Msg  : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Air_Vehicule_Configuration_Msg
     (This : in out Route_Aggregator_Service;
      Msg  : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Ground_Vehicle_Configuration_Msg
     (This : in out Route_Aggregator_Service;
      Msg  : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Surface_Vehicle_Configuration_Msg
     (This : in out Route_Aggregator_Service;
      Msg  : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Unique_Automation_Request_Msg
     (This : in out Route_Aggregator_Service;
      Msg  : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Impact_Automation_Request_Msg
     (This : in out Route_Aggregator_Service;
      Msg  : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Task_Plan_Options_Msg
     (This : in out Route_Aggregator_Service;
      Msg  : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Route_Request_Msg
     (This : in out Route_Aggregator_Service;
      Msg  : Any_LMCP_Message);

   ---------------
   -- Construct --
   ---------------

   procedure Construct
     (This : in out Route_Aggregator_Service)
   is
      pragma Unreferenced (This);
      A : Integer;
      pragma Unreferenced (A);
   begin
      null;
   end Construct;

   ---------------------------------
   -- Registry_Service_Type_Names --
   ---------------------------------

   function Registry_Service_Type_Names return Service_Type_Names_List
   is
      Name : constant Service_Type_Name := Instance (Capacity => Service_Type_Name_Max_Length,
                                                     Content  => Type_Name);
   begin
      return Service_Type_Names_List'(1 => Name);
   end Registry_Service_Type_Names;

   ------------
   -- Create --
   ------------

   function Create return Any_Service is
     (new Route_Aggregator_Service);

   ---------------
   -- Configure --
   ---------------

   overriding
   procedure Configure
     (This     : in out Route_Aggregator_Service;
      XML_Node : DOM.Core.Element;
      Result   : out Boolean)
   is
      Str_Base_Path : Dynamic_String := This.Work_Directory_Path;
      UInt32_Entity_ID : UInt32 := This.Entity_Id;

      UInt32_Lmcp_Message_Size_Max : UInt32 := 1000000;
      --   Sstr_Errors : Dynamic_String;

      Str_Component_Type      : String :=   Get_Attribute (XML_Node, Name => "STRING_XML_TYPE");
      Str_Component_Fast_Plan : String :=   Get_Attribute (XML_Node, Name => "STRING_XML_FAST_PLAN");
      Unused : Boolean;
      use afrl.cmasi.EntityConfiguration.String_Vectors;
      EntityConfiguration_Descendants : Afrl.Cmasi.EntityConfiguration.String_Vectors.Vector := Afrl.Cmasi.EntityConfiguration.EntityConfiguration_Descendants;
      use afrl.cmasi.EntityState.String_Vectors;
      EntityState_Descendants : afrl.cmasi.EntityState.String_Vectors.Vector := afrl.cmasi.EntityState.EntityState_Descendants;

   begin

      if Str_Component_Fast_Plan'Length < 0  then
         This.Fast_Plan := Boolean'Value (Str_Component_Fast_Plan);
      end if;

      --  // track states and configurations for assignment cost matrix calculation
      --  // [EntityStates] are used to calculate costs from current position to first task
      --  // [EntityConfigurations] are used for nominal speed values (all costs are in terms of time to arrive)

      --  // ENTITY CONFIGURATIONS

      This.Add_Subscription_Address (afrl.cmasi.EntityConfiguration.Subscription, Unused);

      for Descendant of EntityConfiguration_Descendants loop
         This.Add_Subscription_Address (Descendant, Unused);
      end loop;

      This.Add_Subscription_Address (afrl.cmasi.EntityState.Subscription, Unused);

      for Descendant of EntityState_Descendants loop
         This.Add_Subscription_Address (Descendant, Unused);
      end loop;

      --  // track requests to kickoff matrix calculation
      This.Add_Subscription_Address (uxas.messages.lmcptask.UniqueAutomationRequest.Subscription, Unused);

      --  // subscribe to task plan options to build matrix
      This.Add_Subscription_Address (uxas.messages.lmcptask.TaskPlanOptions.Subscription, Unused);

      --  // handle batch route requests
      This.Add_Subscription_Address (uxas.messages.route.RouteRequest.Subscription, Unused);

      --  // listen for responses to requests from route planner(s)
      This.Add_Subscription_Address (uxas.messages.route.RoutePlanResponse.Subscription, Unused);

      Result := True;
   end Configure;

   ----------------
   -- Initialize --
   ----------------

   overriding
   procedure Initialize
     (This   : in out Route_Aggregator_Service;
      Result : out Boolean)
   is
      pragma Unreferenced (This); -- since not doing the Timers
   begin

      Result := True;
   end Initialize;

   ----------------------------------------------
   -- Process_Received_Serialized_LMCP_Message --
   ----------------------------------------------

   overriding
   procedure Process_Received_Serialized_LMCP_Message
     (This             : in out Route_Aggregator_Service;
      Received_Message : not null Any_Addressed_Attributed_Message;
      Result           : out Boolean)
   is
      pragma Unreferenced (This, Received_Message, Result); -- unless we need to implement this
   begin
      --  we may not need to implement this procedure for our demo
      --  pragma Compile_Time_Warning (Standard.True, "Process_Received_Serialized_LMCP_Message unimplemented");
      raise Program_Error with "Unimplemented procedure Process_Received_Serialized_LMCP_Message";
   end Process_Received_Serialized_LMCP_Message;

   -----------------------------------
   -- Process_Received_LMCP_Message --
   -----------------------------------
   overriding
   procedure Process_Received_LMCP_Message
     (This : in out Route_Aggregator_Service;
      Received_Message : not null Any_LMCP_Message;
      Result           : out Boolean)
   is
   begin
      --  if (uxas::messages::route::isRoutePlanResponse(receivedLmcpMessage->m_object.get()))
      if    Received_Message.Payload.all in RoutePlanResponse'Class           then
         This.Handle_Route_Plan_Response_Msg (Received_Message);
         SPARK.Check_All_Route_Plans (This);

         --  else if (uxas::messages::route::isRouteRequest(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in RouteRequest'Class                then
         This.Handle_Route_Request_Msg (Received_Message);

         --  else if (std::dynamic_pointer_cast<afrl::cmasi::AirVehicleState>(receivedLmcpMessage->m_object))
      elsif Received_Message.Payload.all in AirVehicleState'Class             then
         This.Handle_Air_Vehicule_State_Msg (Received_Message);

         --  else if (afrl::vehicles::isGroundVehicleState(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in GroundVehicleState'Class          then
         This.Handle_Ground_Vehicles_State_Msg (Received_Message);

         --  else if (afrl::vehicles::isSurfaceVehicleState(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in SurfaceVehicleState'Class         then
         This.Handle_Surface_Vehicle_State_Msg (Received_Message);

         --  else if (std::dynamic_pointer_cast<afrl::cmasi::AirVehicleConfiguration>(receivedLmcpMessage->m_object))
      elsif Received_Message.Payload.all in AirVehicleConfiguration'Class     then
         This.Handle_Air_Vehicule_Configuration_Msg (Received_Message);

         --  else if (afrl::vehicles::isGroundVehicleConfiguration(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in GroundVehicleConfiguration'Class  then
         This.Handle_Ground_Vehicle_Configuration_Msg (Received_Message);

         --  else if (afrl::vehicles::isSurfaceVehicleConfiguration(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in SurfaceVehicleConfiguration'Class then
         This.Handle_Surface_Vehicle_Configuration_Msg (Received_Message);

         --  else if (uxas::messages::task::isUniqueAutomationRequest(receivedLmcpMessage->m_object.get())
      elsif Received_Message.Payload.all in UniqueAutomationRequest'Class     then
         This.Handle_Unique_Automation_Request_Msg (Received_Message);
         SPARK.Check_All_Task_Option_Received (This => This);

         --  else if (afrl::impact::isImpactAutomationRequest(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in ImpactAutomationRequest'Class     then
         This.Handle_Impact_Automation_Request_Msg (Received_Message);
         SPARK.Check_All_Task_Option_Received (This => This);

         --  else if (uxas::messages::task::isTaskPlanOptions(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in TaskPlanOptions'Class             then
         This.Handle_Task_Plan_Options_Msg (Received_Message);
         SPARK.Check_All_Task_Option_Received (This => This);

      end if;
      Result := False;
   end Process_Received_LMCP_Message;

   --------------------------
   -- Handle_Route_Request --
   --------------------------
   procedure Handle_Route_Request_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is

      use  Uxas.Messages.Route.RouteRequest.SPARK_Boundary;
      Route_Request : My_RouteRequest := Wrap ( RouteRequest_Acc(RouteRequest_Any(Msg.Payload)).all);

   begin
      SPARK.Handle_Route_Request (This          => This,
                                 Route_Request => Route_Request);
   end Handle_Route_Request_Msg;

   ------------------------------------
   -- Handle_Route_Plan_Response_Msg --
   ------------------------------------

   --  This message is the fulfillment of a single vehicle route  plan request which the *Aggregator* catalogues until the
   --  until the complete set of expected responses is received

   procedure Handle_Route_Plan_Response_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      Route_Plan : constant RoutePlanResponse_Any := RoutePlanResponse_Any (Msg.Payload);
      C : Int64_Route_Plan_Responses_Maps.Cursor;
      C2 : Int64_Pair_Int64_Route_Plan_Maps.Cursor;
      Inserted : Boolean;
      Wrapped_RoutePlan : constant Route_Plan_Responses_Holder := Route_Plan_Responses_Holder'(Content => Wrap (RoutePlanResponse_Acc (Route_Plan).all));
      Pair  : Pair_Int64_Route_Plan;
   begin
      --  m_routePlanResponses[rplan->getResponseID()] = rplan;
      Int64_Route_Plan_Responses_Maps.Insert
        (This.Route_Plan_Responses,
         Key => Route_Plan.getResponseID,
         New_Item  => Wrapped_RoutePlan,
         Position  => C,
         Inserted  => Inserted);
      if not Inserted then
         Int64_Route_Plan_Responses_Maps.Replace_Element (This.Route_Plan_Responses, C, Wrapped_RoutePlan);
      end if;

      for P of Route_Plan.getRouteResponses.all loop
         declare
            RoutePlan_Clone : My_RoutePlan :=  Wrap (P.all);
         begin

            Pair := Pair_Int64_Route_Plan'(Reponse_ID          => Route_Plan.getResponseID,
                                           Returned_Route_Plan => RoutePlan_Clone);

            Int64_Pair_Int64_Route_Plan_Maps.Insert
              (This.Route_Plan,
               Key       => Get_RouteID (RoutePlan_Clone),
               New_Item  => Pair,
               Position  => C2,
               Inserted  => Inserted);
            if not Inserted then
               Int64_Pair_Int64_Route_Plan_Maps.Replace_Element (This.Route_Plan, C2, Pair);
            end if;
         end;
      end loop;
   end Handle_Route_Plan_Response_Msg;

   -----------------------------------
   -- Handle_Air_Vehicule_State_Msg --
   -----------------------------------

   --  Describes the actual state of a vehicle in the system including position, speed, and fuel status. This message is
   --  used to create routes and cost estimates from the associated vehicle position and heading to the task option start locations
   --  as the vheclis is identify as a Air Vehicles store is id in the Air Vheicles Set
   procedure Handle_Air_Vehicule_State_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      AirVehicle : constant EntityState_Any := EntityState_Any (Msg.Payload);
      --  int64_t id = std::static_pointer_cast<afrl::cmasi::EntityState>(receivedLmcpMessage->m_object)->getID();
      ID : constant Int64 :=  AirVehicle.getID;
      C : Int64_Entity_State_Maps.Cursor;
      Wrapped_AirVehicle : constant Entity_State_Holder := Entity_State_Holder'(Content => Wrap (EntityState (AirVehicle.all)));
      Inserted : Boolean;
      use Int64_Sets;

   begin

      Int64_Entity_State_Maps.Insert
        (This.Entity_State,
         Key       => ID,
         New_Item  => Wrapped_AirVehicle,
         Position  => C,
         Inserted  => Inserted);
      if not Inserted then
         Int64_Entity_State_Maps.Replace_Element (This.Entity_State, C, Wrapped_AirVehicle);
      end if;

      if not Contains (This.Air_Vehicules, ID) then
         Insert (This.Air_Vehicules, ID);
      end if;
   end Handle_Air_Vehicule_State_Msg;

   --------------------------------------
   -- Handle_Ground_Vehicles_State_Msg --
   --------------------------------------

   --  Describes the actual state of a vehicle in the system including position, speed, and fuel status. This message is
   --  used to create routes and cost estimates from the associated vehicle position and heading to the task option start locations
   --  as the vheclis is identify as a Ground Vehicles store is id in the Ground Vheicles Set
   procedure Handle_Ground_Vehicles_State_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      GroundVehicles : constant EntityState_Any := EntityState_Any (Msg.Payload);
      ID : constant Int64 :=  GroundVehicles.getID;

      C : Int64_Entity_State_Maps.Cursor;
      Wrapped_GroundVehicles : constant Entity_State_Holder := Entity_State_Holder'(Content => Wrap (EntityState (GroundVehicles.all)));
      Inserted : Boolean;
      use Int64_Sets;
   begin

      Int64_Entity_State_Maps.Insert
        (This.Entity_State,
         Key       => ID,
         New_Item  => Wrapped_GroundVehicles,
         Position  => C,
         Inserted  => Inserted);
      if not Inserted then
         Int64_Entity_State_Maps.Replace_Element (This.Entity_State, C, Wrapped_GroundVehicles);
      end if;

      if not Contains (This.Ground_Vehicles, ID) then
         Insert (This.Ground_Vehicles, ID);
      end if;
   end Handle_Ground_Vehicles_State_Msg;

   --------------------------------------
   -- Handle_Surface_Vehicle_State_Msg --
   --------------------------------------

   --  Describes the actual state of a vehicle in the system including position, speed, and fuel status. This message is
   --  used to create routes and cost estimates from the associated vehicle position and heading to the task option start locations
   --  as the vheclis is identify as a Surface Vehicles store is id in the Surface Vheicles Set
   procedure Handle_Surface_Vehicle_State_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      SurfaceVehicles : constant EntityState_Any := EntityState_Any (Msg.Payload);
      ID : constant Int64 :=  SurfaceVehicles.getID;

      C : Int64_Entity_State_Maps.Cursor;
      Wrapped_SurfacesVehicles : constant Entity_State_Holder := Entity_State_Holder'(Content => Wrap (EntityState (SurfaceVehicles.all)));
      Inserted : Boolean;
      use Int64_Sets;
   begin

      Int64_Entity_State_Maps.Insert
        (This.Entity_State,
         Key       => ID,
         New_Item  => Wrapped_SurfacesVehicles,
         Position  => C,
         Inserted  => Inserted);
      if not Inserted then
         Int64_Entity_State_Maps.Replace_Element (This.Entity_State, C, Wrapped_SurfacesVehicles);
      end if;

      if not Contains (This.Surface_Vehicles, ID) then
         Insert (This.Surface_Vehicles, ID);
      end if;
   end Handle_Surface_Vehicle_State_Msg;

   -------------------------------------------
   -- Handle_Air_Vehicule_Configuration_Msg --
   -------------------------------------------

   --  Vehicle capabilities (e.g. allowable speeds) are described by entity configuration messages.
   --  This service uses the *EntityConfiguration* to determine which type of vehicle
   --  corresponds to a specific ID so that ground planners are used for ground vehicles and air planners are used for aircraft.
   --  as the vheclis is identify as a Air Vehicles store is id in the Air Vheicles Set

   procedure Handle_Air_Vehicule_Configuration_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      AirVehicle : constant EntityConfiguration_Any := EntityConfiguration_Any (Msg.Payload);
      ID : constant Int64 := AirVehicle.getID;
      C : Int64_Entity_Configuration_Maps.Cursor;
      Wrapped_AirVehicle : constant Entity_Configuration_Holder := Entity_Configuration_Holder'(Content => Wrap (EntityConfiguration (AirVehicle.all)));
      Inserted : Boolean;
      use Int64_Sets;
   begin

      Int64_Entity_Configuration_Maps.Insert
        (This.Entity_Configuration,
         Key       => ID,
         New_Item  => Wrapped_AirVehicle,
         Position  => C,
         Inserted  => Inserted);
      if not Inserted then
         Int64_Entity_Configuration_Maps.Replace_Element (This.Entity_Configuration, C, Wrapped_AirVehicle);
      end if;

      if not Contains (This.Air_Vehicules, ID) then
         Insert (This.Air_Vehicules, ID);
      end if;
   end Handle_Air_Vehicule_Configuration_Msg;

   ---------------------------------------------
   -- Handle_Ground_Vehicle_Configuration_Msg --
   ---------------------------------------------

   --  Vehicle capabilities (e.g. allowable speeds) are described by entity configuration messages.
   --  This service uses the *EntityConfiguration* to determine which type of vehicle
   --  corresponds to a specific ID so that ground planners are used for ground vehicles and air planners are used for aircraft.
   --  as the vheclis is identify as a Ground Vehicles store is id in the Ground Vheicles Set
   procedure Handle_Ground_Vehicle_Configuration_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      GroundVehicle : constant EntityConfiguration_Any := EntityConfiguration_Any (Msg.Payload);
      ID : constant Int64 := GroundVehicle.getID;
      C : Int64_Entity_Configuration_Maps.Cursor;
      Wrapped_GroundVehicles : constant Entity_Configuration_Holder := Entity_Configuration_Holder'(Content => Wrap (EntityConfiguration (GroundVehicle.all)));
      Inserted : Boolean;
      use Int64_Sets;
   begin

      Int64_Entity_Configuration_Maps.Insert
        (This.Entity_Configuration,
         Key       => ID,
         New_Item  => Wrapped_GroundVehicles,
         Position  => C,
         Inserted  => Inserted);
      if not Inserted then
         Int64_Entity_Configuration_Maps.Replace_Element (This.Entity_Configuration, C, Wrapped_GroundVehicles);
      end if;

      if not Contains (This.Ground_Vehicles, ID) then
         Insert (This.Ground_Vehicles, ID);
      end if;
   end Handle_Ground_Vehicle_Configuration_Msg;

   ----------------------------------------------
   -- Handle_Surface_Vehicle_Configuration_Msg --
   ----------------------------------------------

   --  Vehicle capabilities (e.g. allowable speeds) are described by entity configuration messages.
   --  This service uses the *EntityConfiguration* to determine which type of vehicle
   --  corresponds to a specific ID so that ground planners are used for ground vehicles and air planners are used for aircraft.
   --  as the vheclis is identify as a Surface Vehicles store is id in the Surface Vheicles Set
   procedure Handle_Surface_Vehicle_Configuration_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)

   is
      SurfaceVehicle : constant EntityConfiguration_Any := EntityConfiguration_Any (Msg.Payload);
      ID : constant  Int64 := SurfaceVehicle.getID;
      C : Int64_Entity_Configuration_Maps.Cursor;
      Wrapped_SurfaceVehicles : constant Entity_Configuration_Holder := Entity_Configuration_Holder'(Content => Wrap (EntityConfiguration (SurfaceVehicle.all)));
      Inserted : Boolean;
      use Int64_Sets;
   begin

      Int64_Entity_Configuration_Maps.Insert
        (This.Entity_Configuration,
         Key       => ID,
         New_Item  => Wrapped_SurfaceVehicles,
         Position  => C,
         Inserted  => Inserted);
      if not Inserted then
         Int64_Entity_Configuration_Maps.Replace_Element (This.Entity_Configuration, C, Wrapped_SurfaceVehicles);
      end if;

      if not Contains (This.Surface_Vehicles, ID) then
         Insert (This.Surface_Vehicles, ID);
      end if;
   end Handle_Surface_Vehicle_Configuration_Msg;

   ------------------------------------------
   -- Handle_Unique_Automation_Request_Msg --
   ------------------------------------------

   --  Primary message that initiates the collection of options sent from each *Task* via the *TaskPlanOptions* message.
   --  A list of all *Tasks* included in the *UniqueAutomationRequest* is made upon reception of this message and later used to ensure that
   --  all included *Tasks* have responded.
   procedure Handle_Unique_Automation_Request_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      AutomationRequest : constant UniqueAutomationRequest_Any := UniqueAutomationRequest_Any (Msg.Payload);
      C : Int64_Unique_Automation_Request_Maps.Cursor;
      Wrapped_AutomationRequest :  constant UniqueAutomationRequest_Handler := UniqueAutomationRequest_Handler'(Content => Wrap (UniqueAutomationRequest (AutomationRequest.all)));
      Inserted : Boolean;
   begin
      Int64_Unique_Automation_Request_Maps.Insert
        (This.Unique_Automation_Request,
         Key       => This.Auto_Request_Id,
         New_Item  => Wrapped_AutomationRequest,
         Position  => C,
         Inserted  => Inserted);
      This.Auto_Request_Id := This.Auto_Request_Id + 1;
   end Handle_Unique_Automation_Request_Msg;

   ------------------------------------------
   -- Handle_Impact_Automation_Request_Msg --
   ------------------------------------------

   --  Primary message that initiates the collection of options sent from each *Task* via the *TaskPlanOptions* message.
   --  A list of all *Tasks* included in the *UniqueAutomationRequest* is made upon reception of this message and later used to ensure that
   --  all included *Tasks* have responded.
   procedure Handle_Impact_Automation_Request_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      Impact_Automation_Request : constant ImpactAutomationRequest_Any := ImpactAutomationRequest_Any (Msg.Payload);
      Unique_Automation_Request : UniqueAutomationRequest_Any;

      C : Int64_Unique_Automation_Request_Maps.Cursor;
      Wrapped_UniqueAutomationRequest : UniqueAutomationRequest_Handler;
      Inserted : Boolean;
   begin
      Unique_Automation_Request.setOriginalRequest (OriginalRequest => Impact_Automation_Request.getTrialRequest);

      Unique_Automation_Request.setRequestID (This.Auto_Request_Id);

      Wrapped_UniqueAutomationRequest := UniqueAutomationRequest_Handler'(Content => Wrap (UniqueAutomationRequest (Unique_Automation_Request.all)));

      Int64_Unique_Automation_Request_Maps.Insert
        (This.Unique_Automation_Request,
          Key       => This.Auto_Request_Id,
          New_Item  => Wrapped_UniqueAutomationRequest,
          Position  => C,
          Inserted  => Inserted);
      This.Auto_Request_Id := This.Auto_Request_Id + 1;
   end Handle_Impact_Automation_Request_Msg;

   ----------------------------------
   -- Handle_Task_Plan_Options_Msg --
   ----------------------------------

   --  Store task options and check to see if this message completes
   procedure Handle_Task_Plan_Options_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      Task_Option : constant TaskPlanOptions_Any := TaskPlanOptions_Any (Msg.Payload);

      C : Int64_Task_Plan_Options_Maps.Cursor;
      Wrapped_TaskOption : constant Task_Plan_Options_Holder := Task_Plan_Options_Holder'(Content => Wrap (TaskPlanOptions_Acc (Task_Option).all));
      Inserted : Boolean;

   begin

      --  m_taskOptions[taskOptions->getTaskID()] = taskOptions;
      Int64_Task_Plan_Options_Maps.Insert
        (This.Task_Plan_Options,
          Key => Task_Option.getTaskID,
          New_Item  => Wrapped_TaskOption,
          Position  => C,
          Inserted  => Inserted);
   end Handle_Task_Plan_Options_Msg;

   procedure XML_Write (This  : Route_Aggregator_Service;
                        S     : access Ada.Streams.Root_Stream_Type'Class;
                        Level : Natural) is
      use Int64_Pending_Route_Matrix;
      use Int64_Route_Plan_Responses_Maps;
      use Int64_Aggregator_Task_Option_Pair_Maps;
      use Int64_Pending_Auto_Req_Matrix;
      use Int64_Task_Plan_Options_Maps;
      use Int64_Unique_Automation_Request_Maps;
      use Int64_Entity_Configuration_Maps;
      use Int64_Entity_State_Maps;
      use Int64_Pair_Int64_Route_Plan_Maps;
   begin
      String'Write (S, LeftPad ("<FastPlan>" & Boolean'Image (This.Fast_Plan) & "</FastPlan>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<EntityStates>" & ASCII.LF, Level));
      for Cursor in This.Entity_State loop

         String'Write (S, LeftPad ("<Element>" & ASCII.LF, Level + 1));

         String'Write (S, LeftPad ("<Key>" & Int64'Image (Int64_Entity_State_Maps.Key (This.Entity_State, Cursor)) & "</Key>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("<EntityState>" & ASCII.LF, Level + 2));
         XML_Output (Unwrap (Int64_Entity_State_Maps.Element (This.Entity_State, Cursor).Content), S, Level + 3);
         String'Write (S, LeftPad ("</EntityState>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("</Element>" & ASCII.LF, Level + 1));

      end loop;
      String'Write (S, LeftPad ("</EntityStates>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<EntityConfigurations>" & ASCII.LF, Level));
      for Cursor in This.Entity_Configuration loop

         String'Write (S, LeftPad ("<Element>" & ASCII.LF, Level + 1));

         String'Write (S, LeftPad ("<Key>" & Int64'Image (Int64_Entity_Configuration_Maps.Key (THis.Entity_Configuration, Cursor)) & "</Key>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("<EntityConfiguration>" & ASCII.LF, Level + 2));
         XML_Output (Unwrap (Int64_Entity_Configuration_Maps.Element (This.Entity_Configuration, Cursor).Content), S, Level + 3);
         String'Write (S, LeftPad ("</EntityConfiguration>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("</Element>" & ASCII.LF, Level + 1));

      end loop;
      String'Write (S, LeftPad ("</EntityConfigurations>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<AirVehicles>" & ASCII.LF, Level));
      for ID of This.Air_Vehicules loop
         String'Write (S, LeftPad ("<VehicleID>" & Int64'Image (ID) & "</VehicleID>" & ASCII.LF, Level + 1));
      end loop;
      String'Write (S, LeftPad ("</AirVehicles>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<GroundVehicles>" & ASCII.LF, Level));
      for ID of This.Ground_Vehicles loop
         String'Write (S, LeftPad ("<VehicleID>" & Int64'Image (ID) & "</VehicleID>" & ASCII.LF, Level + 1));
      end loop;
      String'Write (S, LeftPad ("</GroundVehicles>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<SurfaceVehicles>" & ASCII.LF, Level));
      for ID of This.Surface_Vehicles loop
         String'Write (S, LeftPad ("<VehicleID>" & Int64'Image (ID) & "</VehicleID>" & ASCII.LF, Level + 1));
      end loop;
      String'Write (S, LeftPad ("</SurfaceVehicles>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<AutoRequestId>" & Int64'Image (This.Auto_Request_Id) & "</AutoRequestId>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<UniqueAutomationRequests>" & ASCII.LF, Level));
      for Cursor in This.Unique_Automation_Request loop

         String'Write (S, LeftPad ("<Element>" & ASCII.LF, Level + 1));

         String'Write (S, LeftPad ("<Key>" & Int64'Image (Int64_Unique_Automation_Request_Maps.Key (THis.Unique_Automation_Request, Cursor)) & "</Key>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("<UniqueAutomationRequest>" & ASCII.LF, Level + 2));
         XML_Output (Unwrap (Int64_Unique_Automation_Request_Maps.Element (This.Unique_Automation_Request, Cursor).Content), S, Level + 3);
         String'Write (S, LeftPad ("</UniqueAutomationRequest>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("</Element>" & ASCII.LF, Level + 1));

      end loop;
      String'Write (S, LeftPad ("</UniqueAutomationRequests>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<TaskOptions>" & ASCII.LF, Level));
      for Cursor in This.Task_Plan_Options loop

         String'Write (S, LeftPad ("<Element>" & ASCII.LF, Level + 1));

         String'Write (S, LeftPad ("<Key>" & Int64'Image (Int64_Task_Plan_Options_Maps.Key (THis.Task_Plan_Options, Cursor)) & "</Key>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("<UniqueAutomationRequest>" & ASCII.LF, Level + 2));
         XML_Output (Unwrap (Int64_Task_Plan_Options_Maps.Element (This.Task_Plan_Options, Cursor).Content), S, Level + 3);
         String'Write (S, LeftPad ("</UniqueAutomationRequest>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("</Element>" & ASCII.LF, Level + 1));

      end loop;
      String'Write (S, LeftPad ("</TaskOptions>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<RouteId>" & Int64'Image (This.Route_Id) & "</RouteId>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<RoutePlans>" & ASCII.LF, Level));
      for Cursor in This.Route_Plan loop

         String'Write (S, LeftPad ("<Element>" & ASCII.LF, Level + 1));

         String'Write (S, LeftPad ("<Key>" & Int64'Image (Int64_Pair_Int64_Route_Plan_Maps.Key (THis.Route_Plan, Cursor)) & "</Key>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("<ReponseID>" & Int64'Image (Int64_Pair_Int64_Route_Plan_Maps.Element (This.Route_Plan, Cursor).Reponse_ID) & "</ReponseID>" & ASCII.LF, Level));

         String'Write (S, LeftPad ("<Returned_Route_Plan>" & ASCII.LF, Level + 2));
         XML_Output (Unwrap (Int64_Pair_Int64_Route_Plan_Maps.Element (This.Route_Plan, Cursor).Returned_Route_Plan), S, Level + 3);
         String'Write (S, LeftPad ("</Returned_Route_Plan>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("</Element>" & ASCII.LF, Level + 1));

      end loop;
      String'Write (S, LeftPad ("</RoutePlans>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<PendingAutoReq>" & ASCII.LF, Level));
      for Cursor in This.Pending_Auto_Req loop

         String'Write (S, LeftPad ("<Element>" & ASCII.LF, Level + 1));

         String'Write (S, LeftPad ("<Key>" & Int64'Image (Int64_Pending_Auto_Req_Matrix.Key (THis.Pending_Auto_Req, Cursor)) & "</Key>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("<PendingReq>" & ASCII.LF, Level + 2));
         for ID of Int64_Pending_Auto_Req_Matrix.Element (This.Pending_Auto_Req, Cursor) loop
            String'Write (S, LeftPad ("<RequestID>" & Int64'Image (ID) & "</RequestID>" & ASCII.LF, Level + 3));
         end loop;
         String'Write (S, LeftPad ("</PendingReq>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("</Element>" & ASCII.LF, Level + 1));

      end loop;
      String'Write (S, LeftPad ("</PendingAutoReq>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<RouteTaskPairing>" & ASCII.LF, Level));
      for Cursor in This.Route_Task_Pairing loop

         String'Write (S, LeftPad ("<Element>" & ASCII.LF, Level + 1));

         String'Write (S, LeftPad ("<Key>" & Int64'Image (Int64_Aggregator_Task_Option_Pair_Maps.Key (THis.Route_Task_Pairing, Cursor)) & "</Key>" & ASCII.LF, Level + 2));
         String'Write (S, LeftPad ("<AggregatorTaskOptionPair>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("<VehicleId>"      & Int64'Image (Int64_Aggregator_Task_Option_Pair_Maps.Element (THis.Route_Task_Pairing, Cursor).VehicleId)      & "</VehicleId>"      & ASCII.LF, Level + 3));
         String'Write (S, LeftPad ("<PrevTaskId>"     & Int64'Image (Int64_Aggregator_Task_Option_Pair_Maps.Element (THis.Route_Task_Pairing, Cursor).PrevTaskId)     & "</PrevTaskId>"     & ASCII.LF, Level + 3));
         String'Write (S, LeftPad ("<PrevTaskOption>" & Int64'Image (Int64_Aggregator_Task_Option_Pair_Maps.Element (THis.Route_Task_Pairing, Cursor).PrevTaskOption) & "</PrevTaskOption>" & ASCII.LF, Level + 3));
         String'Write (S, LeftPad ("<TaskId>"         & Int64'Image (Int64_Aggregator_Task_Option_Pair_Maps.Element (THis.Route_Task_Pairing, Cursor).TaskId)         & "</TaskId>"         & ASCII.LF, Level + 3));
         String'Write (S, LeftPad ("<TaskOption>"     & Int64'Image (Int64_Aggregator_Task_Option_Pair_Maps.Element (THis.Route_Task_Pairing, Cursor).TaskOption)     & "</TaskOption>"     & ASCII.LF, Level + 3));

         String'Write (S, LeftPad ("</AggregatorTaskOptionPair>" & ASCII.LF, Level + 2));
         String'Write (S, LeftPad ("</Element>" & ASCII.LF, Level + 1));

      end loop;
      String'Write (S, LeftPad ("</RouteTaskPairing>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<RouteRequestId>" & Int64'Image (This.Route_Request_ID) & "</RouteRequestId>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<RoutePlanResponses>" & ASCII.LF, Level));
      for Cursor in This.Route_Plan_Responses loop

         String'Write (S, LeftPad ("<Element>" & ASCII.LF, Level + 1));

         String'Write (S, LeftPad ("<Key>" & Int64'Image (Int64_Route_Plan_Responses_Maps.Key (This.Route_Plan_Responses, Cursor)) & "</Key>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("RoutePlanResponse>" & ASCII.LF, Level + 2));
         XML_Output (Unwrap (Int64_Route_Plan_Responses_Maps.Element (This.Route_Plan_Responses, Cursor).Content), S, Level + 3);
         String'Write (S, LeftPad ("</RoutePlanResponse>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("</Element>" & ASCII.LF, Level + 1));

      end loop;
      String'Write (S, LeftPad ("</RoutePlanResponses>" & ASCII.LF, Level));

      String'Write (S, LeftPad ("<PendingRoute>" & ASCII.LF, Level));
      for Cursor in This.Pending_Route loop

         String'Write (S, LeftPad ("<Element>" & ASCII.LF, Level + 1));

         String'Write (S, LeftPad ("<Key>" & Int64'Image (Int64_Pending_Route_Matrix.Key (This.Pending_Route, Cursor)) & "</Key>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("<PendingRoute>" & ASCII.LF, Level + 2));
         for ID of Int64_Pending_Route_Matrix.Element (This.Pending_Route, Cursor) loop
            String'Write (S, LeftPad ("<RouteID>" & Int64'Image (ID) & "</RouteID>" & ASCII.LF, Level + 3));
         end loop;
         String'Write (S, LeftPad ("</PendingRoute>" & ASCII.LF, Level + 2));

         String'Write (S, LeftPad ("</Element>" & ASCII.LF, Level + 1));

      end loop;
      String'Write (S, LeftPad ("</PendingRoute>" & ASCII.LF, Level));

   end XML_Write;

end uxas.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service;
