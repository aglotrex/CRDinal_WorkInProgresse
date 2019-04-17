

with AVTAS.Lmcp.Object.SPARK_Boundary;              use AVTAS.Lmcp.Object.SPARK_Boundary;

with AFRL.CMASI.Enumerations;
with AFRl.CMASI.AutomationResponse;                 use AFRl.CMASI.AutomationResponse;
with AFRL.CMASI.AutomationRequest;                  use AFRL.CMASI.AutomationRequest;
with AFRL.CMASI.EntityConfiguration;                use AFRL.CMASI.EntityConfiguration;
with AFRL.CMASI.EntityState;                        use AFRL.CMASI.EntityState;
with AFRL.CMASI.LmcpTask;                           use AFRL.CMASI.LmcpTask;
with AFRL.CMASI.KeepInZone;                         use AFRL.CMASI.KeepInZone;
with AFRL.CMASI.KeepOutZone;                        use AFRL.CMASI.KeepOutZone;
with AFRL.CMASI.RemoveTasks;                        use AFRL.CMASI.RemoveTasks;
with AFRL.CMASI.ServiceStatus;                      use AFRL.CMASI.ServiceStatus;
with AFRL.CMASI.KeyValuePair;                       use AFRL.CMASI.KeyValuePair;
with AFRL.CMASI.OperatingRegion;                    use AFRL.CMASI.OperatingRegion;

with AFRL.Impact.ImpactAutomationRequest;           use AFRL.Impact.ImpactAutomationRequest;
with AFRL.Impact.PointOfInterest;                   use AFRL.Impact.PointOfInterest;
with AFRL.Impact.LineOfInterest;                    use AFRL.Impact.LineOfInterest;
with AFRL.Impact.AreaOfInterest;                    use AFRL.Impact.AreaOfInterest;
with AFRL.Impact.ImpactAutomationResponse;          use AFRL.Impact.ImpactAutomationResponse;

with AFRL.CMASI.AirVehicleConfiguration;            use AFRL.CMASI.AirVehicleConfiguration;
with AFRL.CMASI.AirVehicleState;                    use AFRL.CMASI.AirVehicleState;
with Afrl.Vehicles.SurfaceVehicleConfiguration;     use AFRL.Vehicles.SurfaceVehicleConfiguration;
with Afrl.Vehicles.SurfaceVehicleState;             use AFRL.Vehicles.SurfaceVehicleState;
with Afrl.Vehicles.GroundVehicleConfiguration;      use AFRL.Vehicles.GroundVehicleConfiguration;
with AFRL.Vehicles.GroundVehicleState;              use AFRL.Vehicles.GroundVehicleState;

with Avtas.Lmcp.Object;                             use Avtas.Lmcp.Object;

with UxAS.Messages.Lmcptask.TaskAutomationRequest;  use UxAS.Messages.Lmcptask.TaskAutomationRequest;
with UxAS.Messages.Lmcptask.TaskAutomationResponse; use UxAS.Messages.Lmcptask.TaskAutomationResponse;
with UxAS.Messages.Lmcptask.TaskInitialized;        use UxAS.Messages.Lmcptask.TaskInitialized;
with UxAS.Messages.Lmcptask.PlanningState;          use UxAS.Messages.Lmcptask.PlanningState;
with UxAS.Messages.Lmcptask.TaskOption;             use UxAS.Messages.Lmcptask.TaskOption;
with UxAS.Messages.Lmcptask.TaskPlanOptions;        use UxAS.Messages.Lmcptask.TaskPlanOptions;
with UxAS.Messages.Route.RoutePlanRequest;          use UxAS.Messages.Route.RoutePlanRequest;
with UxAS.Messages.Route.Object;                    use UxAS.Messages.Route.Object;
with UxAS.Messages.Route.RouteConstraints;          use  UxAS.Messages.Route.RouteConstraints;

with UxAS.Common.Utilities.Unit_Conversions;        use  UxAS.Common.Utilities.Unit_Conversions;

with DOM.Core.Elements; use DOM.Core.Elements;
with String_Utils; use String_Utils;
with Ada.Strings.Unbounded;

package body UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service is

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Route_Plan_Response_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Air_Vehicule_State_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message);




   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Ground_Vehicles_State_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message);


   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Surface_Vehicle_State_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Air_Vehicule_Configuration_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message);


   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Ground_Vehicle_Configuration_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message);


   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Surface_Vehicle_Configuration_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message);


   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Unique_Automation_Request_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message);

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Impact_Automation_Request_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message);


   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Task_Plan_Options_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message);





   ---------------
   -- Construct --
   ---------------

   procedure Construct
     (This : in out Route_Aggregator_Service)
   is
      A : Integer;
   begin
      A := 0;
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

      Str_Component_Type : String :=   Get_Attribute(XML_Node,Name => "STRING_XML_TYPE");
      Str_Component_Fast_Plan : String :=   Get_Attribute(XML_Node,Name => "STRING_XML_FAST_PLAN");
      Unused : Boolean;



   begin

      --  EntityConfigurationDescendants(
      --        if(Str_Component_Fast_Plan'Length < 0 ) then
      --           THis.Fast_Plan := Boolean'Value(Str_Component_Fast_Plan);
      --        end if;
      --
      --
      --
      --        -- // track states and configurations for assignment cost matrix calculation
      --        -- // [EntityStates] are used to calculate costs from current position to first task
      --        -- // [EntityConfigurations] are used for nominal speed values (all costs are in terms of time to arrive)
      --
      --        -- // ENTITY CONFIGURATIONS
      --        -- addSubscriptionAddress(afrl::cmasi::EntityConfiguration::Subscription);
      --        This.Add_Subscription_Address(AFRL.CMASI.EntityConfiguration.Subscription, Unused);
      --        -- std::vector< std::string > childconfigs = afrl::cmasi::EntityConfigurationDescendants();
      --        -- for(auto child : childconfigs)
      --        --    addSubscriptionAddress(child);
      --
      --
      --        for Descendant of EntityConfiguration_Descendants loop
      --           This.Add_Subscription_Address(Descendant, Unused);
      --        end loop;
      --
      --
      --
      --        -- addSubscriptionAddress(afrl::cmasi::EntityState::Subscription);
      --        THis.Add_Subscription_Address(AFRL.CMASI.EntityState.Subscription, Unused);
      --        -- std::vector< std::string > childstates = afrl::cmasi::EntityStateDescendants();
      --        -- for(auto child : childstates)
      --        --     addSubscriptionAddress(child);
      --        for Descendant of EntityState_Descendants loop
      --           This.Add_Subscription_Address(Descendant, Unused);
      --        end loop;
      --
      --        -- // track requests to kickoff matrix calculation
      --        -- addSubscriptionAddress(uxas::messages::task::UniqueAutomationRequest::Subscription);
      --        This.Add_Subscription_Address(UxAS.Messages.LmcpTask.UniqueAutomationRequest.Subscription, Unused);
      --
      --        -- // subscribe to task plan options to build matrix
      --        -- addSubscriptionAddress(uxas::messages::task::TaskPlanOptions::Subscription);
      --        This.Add_Subscription_Address(UxAS.Messages.LmcpTask.TaskPlanOptions.Subscription, Unused);
      --
      --        -- // handle batch route requests
      --        -- addSubscriptionAddress(uxas::messages::route::RouteRequest::Subscription);
      --        This.Add_Subscription_Address(UxAS.Messages.Route.RouteRequest.Subscription, Unused);
      --
      --        -- // listen for responses to requests from route planner(s)
      --        -- addSubscriptionAddress(uxas::messages::route::RoutePlanResponse::Subscription);
      --        This.Add_Subscription_Address(UxAS.Messages.Route.RoutePlanResponse.Subscription, Unused);


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
      Result           : out Boolean )
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
      -- if (uxas::messages::route::isRoutePlanResponse(receivedLmcpMessage->m_object.get()))
      if    Received_Message.Payload.all in RoutePlanResponse'Class           then
         This.Handle_Route_Plan_Response_Msg(Received_Message);
         Check_All_Route_Plans(This);

         --  else if (uxas::messages::route::isRouteRequest(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in RouteRequest'Class                then
         declare
            Route_Request : constant RouteRequest_Acc := RouteRequest_Acc( Received_Message.Payload);
         begin
            THis.Handle_Route_Request(Route_Request => Route_Request);
         end;

         --  else if (std::dynamic_pointer_cast<afrl::cmasi::AirVehicleState>(receivedLmcpMessage->m_object))
         --      elsif Received_Message.Payload.all in AirVehicleState'Class             then
         --       This.Handle_Air_Vehicule_State_Msg(Received_Message);

         --  else if (afrl::vehicles::isGroundVehicleState(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in GroundVehicleState'Class          then
         This.Handle_Ground_Vehicles_State_Msg(Received_Message);

         --  else if (afrl::vehicles::isSurfaceVehicleState(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in SurfaceVehicleState'Class         then
         This.Handle_Surface_Vehicle_State_Msg(Received_Message);

         --  else if (std::dynamic_pointer_cast<afrl::cmasi::AirVehicleConfiguration>(receivedLmcpMessage->m_object))
      elsif Received_Message.Payload.all in AirVehicleConfiguration'Class     then
         This.Handle_Air_Vehicule_Configuration_Msg(Received_Message);

         --  else if (afrl::vehicles::isGroundVehicleConfiguration(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in GroundVehicleConfiguration'Class  then
         This.Handle_Ground_Vehicle_Configuration_Msg(Received_Message);


         -- else if (afrl::vehicles::isSurfaceVehicleConfiguration(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in SurfaceVehicleConfiguration'Class then
         This.Handle_Surface_Vehicle_Configuration_Msg(Received_Message);


         -- else if (uxas::messages::task::isUniqueAutomationRequest(receivedLmcpMessage->m_object.get())
      elsif Received_Message.Payload.all in UniqueAutomationRequest'Class     then
         This.Handle_Unique_Automation_Request_Msg(Received_Message);
         THis.Check_All_Task_Option_Received;


         --  else if (afrl::impact::isImpactAutomationRequest(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in ImpactAutomationRequest'Class     then
         This.Handle_Impact_Automation_Request_Msg(Received_Message);
         This.Check_All_Task_Option_Received;

         -- else if (uxas::messages::task::isTaskPlanOptions(receivedLmcpMessage->m_object.get()))
      elsif Received_Message.Payload.all in TaskPlanOptions'Class             then
         This.Handle_Task_Plan_Options_Msg(Received_Message);
         This.Check_All_Task_Option_Received;

      end if;
      Result := False;
   end Process_Received_LMCP_Message;


   ------------------------------------
   -- Handle_Route_Plan_Response_Msg --
   ------------------------------------

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Route_Plan_Response_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      -- auto rplan = std::static_pointer_cast<uxas::messages::route::RoutePlanResponse>(receivedLmcpMessage->m_object);
      Route_Plan : constant RoutePlanResponse_Any := RoutePlanResponse_Any(Msg.Payload);
      C : Int64_Route_Plan_Responses_Maps.Cursor;
      C2 : Int64_Pair_Int64_Route_Plan_Maps.Cursor;
      Inserted : Boolean;
      Wrapped_RoutePlan : constant Route_Plan_Responses_Holder := Route_Plan_Responses_Holder'(Content => Route_Plan);
      Pair  : Pair_Int64_Route_Plan;
   begin
      --  m_routePlanResponses[rplan->getResponseID()] = rplan;
      Int64_Route_Plan_Responses_Maps.Insert
        (This.Route_Plan_Responses,
         Key => Route_Plan.GetResponseID,
         New_Item  => Wrapped_RoutePlan,
         Position  => C,
         Inserted  => Inserted);
      if not Inserted then
         Int64_Route_Plan_Responses_Maps.Replace_Element (This.Route_Plan_Responses, C, Wrapped_RoutePlan);
      end if;

      -- for (auto p : rplan->getRouteResponses())
      for P of Route_Plan.GetRouteResponses.all loop
         declare
            RoutePlan_Acc_Clone :constant RoutePlan_Acc := RoutePlan_Acc(P);
         begin

            Pair := Pair_Int64_Route_Plan'(Reponse_ID          => Route_Plan.GetResponseID,
                                           Returned_Route_Plan => RoutePlan_Acc_Clone);

            Int64_Pair_Int64_Route_Plan_Maps.Insert
              (This.Route_Plan,
               Key       => RoutePlan_Acc_Clone.GetRouteID,
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

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Air_Vehicule_State_Msg
     (This : in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      AirVehicle : constant EntityState_Any := EntityState_Any(Msg.Payload);
      --  int64_t id = std::static_pointer_cast<afrl::cmasi::EntityState>(receivedLmcpMessage->m_object)->getID();
      ID :constant Int64 :=  AirVehicle.GetID;
      C : Int64_Entity_State_Maps.Cursor;
      Wrapped_AirVehicle : constant Entity_State_Holder := Entity_State_Holder'(Content => AirVehicle);
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

      -- m_airVehicles.insert(id);
      if not Contains (This.Air_Vehicules,ID) then
         Insert(This.Air_Vehicules,ID);
      end if;
   end Handle_Air_Vehicule_State_Msg;









   --------------------------------------
   -- Handle_Ground_Vehicles_State_Msg --
   --------------------------------------

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Ground_Vehicles_State_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      -- int64_t id = std::static_pointer_cast<afrl::cmasi::EntityState>(receivedLmcpMessage->m_object);
      GroundVehicles : constant EntityState_Any := EntityState_Any(Msg.Payload);
      --  int64_t id = std::static_pointer_cast<afrl::cmasi::EntityState>(receivedLmcpMessage->m_object)->getID();
      ID :constant Int64 :=  GroundVehicles.GetID;

      C : Int64_Entity_State_Maps.Cursor;
      Wrapped_GroundVehicles : constant Entity_State_Holder := Entity_State_Holder'(Content => GroundVehicles);
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

      -- m_groundVehicles.insert(id);
      if not Contains (This.Ground_Vehicles,ID) then
         Insert(This.Ground_Vehicles,ID);
      end if;
   end Handle_Ground_Vehicles_State_Msg;


   --------------------------------------
   -- Handle_Surface_Vehicle_State_Msg --
   --------------------------------------

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Surface_Vehicle_State_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      -- int64_t id = std::static_pointer_cast<afrl::cmasi::EntityState>(receivedLmcpMessage->m_object);
      SurfaceVehicles : constant EntityState_Any := EntityState_Any(Msg.Payload);
      -- int64_t id = std::static_pointer_cast<afrl::cmasi::EntityState>(receivedLmcpMessage->m_object)->getID();
      ID :constant Int64 :=  SurfaceVehicles.GetID;

      C : Int64_Entity_State_Maps.Cursor;
      Wrapped_SurfacesVehicles : constant Entity_State_Holder := Entity_State_Holder'(Content => SurfaceVehicles);
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

      --   m_surfaceVehicles.insert(id);
      if not Contains (This.Surface_Vehicles,ID) then
         Insert(This.Surface_Vehicles,ID);
      end if;
   end Handle_Surface_Vehicle_State_Msg;




   -------------------------------------------
   -- Handle_Air_Vehicule_Configuration_Msg --
   -------------------------------------------
   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Air_Vehicule_Configuration_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      --  int64_t id = std::static_pointer_cast<afrl::cmasi::EntityConfiguration>(receivedLmcpMessage->m_object);
      AirVehicle : constant EntityConfiguration_Any := EntityConfiguration_Any(Msg.Payload);
      --   int64_t id = std::static_pointer_cast<afrl::cmasi::EntityConfiguration>(receivedLmcpMessage->m_object)->getID();
      ID :constant Int64 := AirVehicle.GetID;
      C : Int64_Entity_Configuration_Maps.Cursor;
      Wrapped_AirVehicle : constant Entity_Configuration_Holder := Entity_Configuration_Holder'(Content => AirVehicle);
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

      -- m_airVehicles.insert(id);
      if not Contains (This.Air_Vehicules,ID) then
         Insert(This.Air_Vehicules,ID);
      end if;
   end Handle_Air_Vehicule_Configuration_Msg;

   ---------------------------------------------
   -- Handle_Ground_Vehicle_Configuration_Msg --
   ---------------------------------------------
   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Ground_Vehicle_Configuration_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      --  int64_t id = std::static_pointer_cast<afrl::cmasi::EntityConfiguration>(receivedLmcpMessage->m_object);
      GroundVehicle : constant EntityConfiguration_Any := EntityConfiguration_Any(Msg.Payload);
      --    int64_t id = std::static_pointer_cast<afrl::cmasi::EntityConfiguration>(receivedLmcpMessage->m_object)->getID();
      ID : constant Int64 := GroundVehicle.GetID;
      C : Int64_Entity_Configuration_Maps.Cursor;
      Wrapped_GroundVehicles : constant Entity_Configuration_Holder := Entity_Configuration_Holder'(Content => GroundVehicle);
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

      -- m_groundVehicles.insert(id);
      if not Contains (This.Ground_Vehicles,ID) then
         Insert(This.Ground_Vehicles,ID);
      end if;
   end Handle_Ground_Vehicle_Configuration_Msg;


   ----------------------------------------------
   -- Handle_Surface_Vehicle_Configuration_Msg --
   ----------------------------------------------

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Surface_Vehicle_Configuration_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)

   is
      --  int64_t id = std::static_pointer_cast<afrl::cmasi::EntityConfiguration>(receivedLmcpMessage->m_object);
      SurfaceVehicle : constant EntityConfiguration_Any := EntityConfiguration_Any(Msg.Payload);
      --    int64_t id = std::static_pointer_cast<afrl::cmasi::EntityConfiguration>(receivedLmcpMessage->m_object)->getID();
      ID :constant  Int64 := SurfaceVehicle.GetID;
      C : Int64_Entity_Configuration_Maps.Cursor;
      Wrapped_SurfaceVehicles : constant Entity_Configuration_Holder := Entity_Configuration_Holder'(Content => SurfaceVehicle);
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

      -- m_surfaceVehicles.insert(id);
      if not Contains (This.Surface_Vehicles,ID) then
         Insert(This.Surface_Vehicles,ID);
      end if;
   end Handle_Surface_Vehicle_Configuration_Msg;


   ------------------------------------------
   -- Handle_Unique_Automation_Request_Msg --
   ------------------------------------------

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Unique_Automation_Request_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      --auto areq = std::static_pointer_cast<uxas::messages::task::UniqueAutomationRequest>(receivedLmcpMessage->m_object);
      AutomationRequest : constant UniqueAutomationRequest_Any := UniqueAutomationRequest_Any(Msg.Payload);
      C : Int64_Unique_Automation_Request_Maps.Cursor;
      Wrapped_AutomationRequest :  constant UniqueAutomationRequest_Handler := UniqueAutomationRequest_Handler'(Content => AutomationRequest);
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

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Impact_Automation_Request_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      --  auto sreq = std::static_pointer_cast<afrl::impact::ImpactAutomationRequest>(receivedLmcpMessage->m_object);
      Impact_Automation_Request : constant ImpactAutomationRequest_Any := ImpactAutomationRequest_Any(Msg.Payload);

      --  auto areq = std::shared_ptr<uxas::messages::task::UniqueAutomationRequest>();
      Unique_Automation_Request : UniqueAutomationRequest_Any;

      C : Int64_Unique_Automation_Request_Maps.Cursor;
      Wrapped_UniqueAutomationRequest : UniqueAutomationRequest_Handler;
      Inserted : Boolean;
   begin
      --   areq->setOriginalRequest(sreq->getTrialRequest()->clone());

      Unique_Automation_Request.SetOriginalRequest( OriginalRequest => Impact_Automation_Request.GetTrialRequest);

      --   areq->setRequestID(m_autoRequestId);
      Unique_Automation_Request.SetRequestID(This.Auto_Request_Id +1);

      Wrapped_UniqueAutomationRequest := UniqueAutomationRequest_Handler'(Content => Unique_Automation_Request);

      --  m_uniqueAutomationRequests[m_autoRequestId++] = areq;
      Int64_Unique_Automation_Request_Maps.Insert
        ( This.Unique_Automation_Request,
          Key       => This.Auto_Request_Id,
          New_Item  => Wrapped_UniqueAutomationRequest,
          Position  => C,
          Inserted  => Inserted);
      This.Auto_Request_Id := This.Auto_Request_Id +1;
   end Handle_Impact_Automation_Request_Msg;


   ----------------------------------
   -- Handle_Task_Plan_Options_Msg --
   ----------------------------------

   --  Refactored out of Process_Received_LMCP_Message for readability, comprehension, etc.
   procedure Handle_Task_Plan_Options_Msg
     (This :in out Route_Aggregator_Service;
      Msg : Any_LMCP_Message)
   is
      -- auto taskOptions = std::static_pointer_cast<uxas::messages::task::TaskPlanOptions>(receivedLmcpMessage->m_object);
      Task_Option : constant TaskPlanOptions_Any := TaskPlanOptions_Any(Msg.Payload);

      C : Int64_Task_Plan_Options_Maps.Cursor;
      Wrapped_TaskOption : constant Task_Plan_Options_Holder := Task_Plan_Options_Holder'(Content => Task_Option);
      Inserted : Boolean;

   begin

      -- m_taskOptions[taskOptions->getTaskID()] = taskOptions;
      Int64_Task_Plan_Options_Maps.Insert
        ( This.Task_Plan_Options,
          Key => Task_Option.GetTaskID,
          New_Item  => Wrapped_TaskOption,
          Position  => C,
          Inserted  => Inserted);
   end Handle_Task_Plan_Options_Msg;

   --------------------------
   -- Handle_Route_Request --
   --------------------------

   procedure Handle_Route_Request
     (This         : in out Route_Aggregator_Service;
      Route_Request : RouteRequest_Acc)
   is
      use Int64_Vects;
      use Int64_Sets;
      use Ada.Containers;
   begin

      --  if (request->getVehicleID().empty())
      if (Route_Request.GetVehicleID.Length = 0) then

         --request->getVehicleID().reserve(m_entityStates.size());
         Route_Request.GetVehicleID.Reserve_Capacity(Capacity => This.Entity_State.Capacity);

         declare
            C : Int64_Entity_State_Maps.Cursor := Int64_Entity_State_Maps.First(This.Entity_State);
         begin
            -- for (const auto& v : m_entityStates)
            while Int64_Entity_State_Maps.Has_Element(Container => This.Entity_State,
                                                      Position  => C) loop

               -- request->getVehicleID().push_back(v.second->getID());
               Route_Request.GetVehicleID.Append( Int64_Entity_State_Maps.Element
                                                  (Container => This.Entity_State,
                                                   Position  => C).Content.GetID);
               Int64_Entity_State_Maps.Next(Container => This.Entity_State,
                                            Position  => C);
            end loop;
         end;
      end if;

      for Id_Indx in Route_Request.GetVehicleID.First_Index .. Route_Request.GetVehicleID.Last_Index  loop


         declare

            Vehicles_Id : Int64 := Route_Request.GetVehicleID.Element(Index => Id_Indx);
            -- std::shared_ptr<uxas::messages::route::RoutePlanRequest> planRequest(new uxas::messages::route::RoutePlanRequest);
            Plan_Request : RoutePlanRequest;


            --  m_pendingRoute[request->getRequestID()]
            Pending_Route_Request : Int64_Set := Int64_Pending_Route_Matrix.Element(Container => This.Pending_Route,
                                                                                    Key       => Route_Request.GetRequestID);


         begin

            -- planRequest->setAssociatedTaskID(request->getAssociatedTaskID());
            -- planRequest->setIsCostOnlyRequest(request->getIsCostOnlyRequest());
            -- planRequest->setOperatingRegion(request->getOperatingRegion());
            -- planRequest->setVehicleID(vehicleId);
            -- planRequest->setRequestID(m_routeRequestId);
            Plan_Request.SetAssociatedTaskID (Route_Request.GetAssociatedTaskID);
            Plan_Request.SetIsCostOnlyRequest(Route_Request.GetIsCostOnlyRequest);
            Plan_Request.SetOperatingRegion  (Route_Request.GetOperatingRegion);
            Plan_Request.SetVehicleID        (Vehicles_Id);
            Plan_Request.SetRequestID        (Route_Request.GetRequestID);

            --  m_pendingRoute[request->getRequestID()].insert(m_routeRequestId);
            Int64_Sets.Insert(Container => Pending_Route_Request,
                              New_Item  => This.Route_Request_ID);

            This.Route_Request_ID := This.Route_Request_ID + 1;


            for Indx in Route_Request.GetRouteRequests.First_Index .. Route_Request.GetRouteRequests.Last_Index loop
               -- planRequest->getRouteRequests().push_back(r->clone());
               Plan_Request.GetRouteRequests.Append(Route_Request.GetRouteRequests.Element(Indx));
            end loop;

            declare
               -- std::shared_ptr<avtas::lmcp::Object> pRequest = std::static_pointer_cast<avtas::lmcp::Object>(planRequest);
               P_Request :Avtas.Lmcp.Object.Object_Any := Avtas.Lmcp.Object.Object_Any
                 (Uxas.Messages.Route.Object.Object_Any(Plan_Request));

            begin


               --  if (m_groundVehicles.find(vehicleId) != m_groundVehicles.end())
               if Int64_Sets.Contains(Container => This.Ground_Vehicles,
                                      Item      => Vehicles_Id)
               then

                  -- if (m_fastPlan)
                  if This.Fast_Plan then

                     -- // short-circuit and just plan with straight line planner
                     -- EuclideanPlan(planRequest);
                     This.Euclidean_Plan(Route_Plan_Request => Plan_Request);

                  else

                     -- // send externally
                     -- sendSharedLmcpObjectLimitedCastMessage(uxas::common::MessageGroup::GroundPathPlanner(), pRequest);
                     This.Send_LMCP_Object_Limited_Cast_Message(CastAddress => GroundPathPlanner,
                                                                Msg         => P_Request);

                  end if;
               else

                  -- // send to aircraft planner
                  -- sendSharedLmcpObjectLimitedCastMessage(uxas::common::MessageGroup::AircraftPathPlanner(), pRequest);
                  This.Send_LMCP_Object_Limited_Cast_Message(CastAddress => AircraftPathPlanner,
                                                             Msg         => P_Request);
               end if;
            end;
         end;

      end loop;

      if (This.Fast_Plan) then
         This.Check_All_Route_Plans;
      end if;
   end Handle_Route_Request;


   -- void EuclideanPlan(std::shared_ptr<uxas::messages::route::RoutePlanRequest>);
   procedure Euclidean_Plan(This             : in out Route_Aggregator_Service;
                            Route_Plan_Request : RoutePlanRequest)
   is
      -- uxas::common::utilities::CUnitConversions flatEarth;
      -- int64_t regionId = request->getOperatingRegion();
      -- int64_t vehicleId = request->getVehicleID();
      -- int64_t taskId = request->getAssociatedTaskID();
      Flat_Earth : Unit_Conversions;
      Region_ID   : Int64 := Route_Plan_Request.GetOperatingRegion;
      Vehicles_ID : Int64 := Route_Plan_Request.GetVehicleID;
      Task_ID     : Int64 := Route_Plan_Request.GetAssociatedTaskID;

      -- double speed = 1.0; // default if no speed available
      Speed  : Long_Float := 1.0;

      --  auto response = std::shared_ptr<uxas::messages::route::RoutePlanResponse>(new uxas::messages::route::RoutePlanResponse);
      Response : RoutePlanResponse;
   begin
      --  if (m_entityConfigurations.find(vehicleId) != m_entityConfigurations.end())
      if Int64_Entity_Configuration_Maps.Contains(Container => This.Entity_Configuration,
                                                  Key       => Vehicles_ID);
      then

         --   double speed = m_entityConfigurations[vehicleId]->getNominalSpeed();
         Speed :=Int64_Entity_Configuration_Maps.Element(Container => This.Entity_Configuration,
                                                         Position  => Vehicles_ID).Content.GetNominalSpeed;

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
      for K in Route_Plan_Request.GetRouteRequests'Range loop
         declare
            -- uxas::messages::route::RouteConstraints* routeRequest = request->getRouteRequests().at(k);
            Route_Request : RouteConstraints := Route_Plan_Request.GetRouteRequests.Element(K);

            Route_ID : Int64 := Route_Request.GetRouteID;


            -- Start_Point : Visibility.Point;
            -- End_Point : Visibility.Point;
            Start_North  : Long_Float;
            Start_East   : Long_Float;
            End_North    : Long_Float;
            End_East     : Long_Float;

            -- uxas::messages::route::RoutePlan* plan = new uxas::messages::route::RoutePlan;
            Plan : RoutePlan;

            Line_Dist : Long_Float;
            Pair_Response_Route :  Pair_Int64_Route_Plan;


         begin
            Plan.SetRouteID(Route_ID);

            -- flatEarth.ConvertLatLong_degToNorthEast_m(routeRequest->getStartLocation()->getLatitude(), routeRequest->getStartLocation()->getLongitude(), north, east);
            Flat_Earth.Convert_Lag_Long_DEG_To_North_East_M
              (D_Latitude_DEG  => Route_Request.GetStartLocation.GetLatitude,
               D_Longitude_DEG => Route_Request.GetStartLocation.GetLatitude,
               D_North_M       => Start_North,
               D_East_M        => Start_East);
            -- Start_Point.set_X(Start_East);
            -- Start_Point.set_Y(Start_North);



            -- flatEarth.ConvertLatLong_degToNorthEast_m(routeRequest->getEndLocation()->getLatitude(), routeRequest->getEndLocation()->getLongitude(), north, east);
            Flat_Earth.Convert_Lag_Long_DEG_To_North_East_M
              (D_Latitude_DEG  =>Route_Request.GetEndLocation.GetLatitude,
               D_Longitude_DEG => Route_Request.GetEndLocation.GetLatitude,
               D_North_M       => End_North,
               D_East_M        => End_East);
            -- End_Point.Set_X(End_East );
            -- End_Point.Set_Y(End_North);

            -- -- double linedist = VisiLibity::distance(startPt, endPt);
            -- Line_Dist := Distance(Start_Point , End_Point);
            Line_Dist := Sqrt( ((End_North - Start_North)**2.0) + ((End_East - Start_East)**2.0));

            Plan.SetRouteCost( Line_Dist / Speed * 1000);

            --  m_routePlans[routeId] = std::make_pair(request->getRequestID(), std::shared_ptr<uxas::messages::route::RoutePlan>(plan));
            Int64_Pair_Int64_Route_Plan_Maps.Insert
              (Container => This.Route_Plan,
               Key       => Route_ID,
               New_Item  =>  Pair_Int64_Route_Plan'(Reponse_ID          => Route_Plan_Request.GetRequestID ,
                                                    Returned_Route_Plan => Plan ));

         end;
      end loop;
      -- m_routePlanResponses[response->getResponseID()] = response;
      Int64_Route_Plan_Responses_Maps.Insert
        (Container => Tis.Route_Plan_Responses,
         Key       => Response.GetResponseID,
         New_Item  => Response);

   end Euclidean_Plan;


   procedure Check_All_Task_Option_Received(This : in out Route_Aggregator_Service)
   is
      C : Int64_Unique_Automation_Request_Maps.Cursor := Int64_Unique_Automation_Request_Maps.First(Container => THis.Unique_Automation_Request);
   begin
      while Int64_Unique_Automation_Request_Maps.Has_Element(Container => This.Unique_Automation_Request,
                                                             Position  => C) loop

         declare

            -- // check that to see if all options from all tasks have been received for this request
            -- bool isAllReceived{true};
            Is_All_Received : Boolean := True;

            -- areqIter->second
            Request : UniqueAutomationRequest_Handler := Int64_Unique_Automation_Request_Maps.Element(Container => This.Unique_Automation_Request,

                                                                                                      Position  => C);

            -- areqIter->first
            Index_Request : Int64 := Int64_Unique_Automation_Request_Maps.Key(Container => This.Unique_Automation_Request,
                                                                              Position  => C)
            begin

               -- for (size_t t = 0; t < areqIter->second->getOriginalRequest()->getTaskList().size(); t++)
               for T in Unique_Automation_Request.Content.GetOriginalRequest.GetTaskList'Range loop


                  declare
                     -- int64_t taskId = areqIter->second->getOriginalRequest()->getTaskList().at(t);
                     Task_ID : Int64 := Unique_Automation_Request.Content.GetOriginalRequest.GetTaskList.Element(Index => T);
                  begin

                     -- if (m_taskOptions.find(taskId) == m_taskOptions.end())
                     if Int64_Task_Plan_Options_Maps.Find(Container => This.Task_Plan_Options,
                                                          Key       => Task_ID )
                     then
                        Is_All_Received := False;
                        Break;
                     end if;
                  end;


               end loop;

               --  if (isAllReceived)
               if Is_All_Received then


                  -- BuildMatrixRequests(areqIter->first, areqIter->second);
                  This.Build_Matrix_Requests
                    (ReqID => Index_Request,
                     Areq  => Unique_Automation_Request );
               end if
            end;

            --  areqIter++;
            Int64_Unique_Automation_Request_Maps.Next(Container => This.Unique_Automation_Request,
                                                      Position  => C);
         end loop;
      end Check_All_Task_Option_Received;


      procedure Check_All_Route_Plans(This : in out Route_Aggregator_Service)
      is
         C : Int64_Pending_Route_Matrix :=
           Int64_Pending_Route_Matrix.First(Container => This.Pending_Route);

         I : Int64_Pending_Auto_Req_Matrix :=
           Int64_Pending_Auto_Req_Matrix.First(Container => THis.Pending_Auto_Req);
      begin

         --  // check pending route requests
         -- auto i = m_pendingRoute.begin();
         -- while (i != m_pendingRoute.end())

         while Int64_Pending_Route_Matrix.Has_Element(Container => This.Pending_Route ,
                                                      Position  => C);
         loop
            declare
               -- bool isFulfilled = true;
               Is_Fulfilled : Boolean := True;

               -- i->first()
               Route_Id : Int64 :=
                 Int64_Pending_Route_Matrix.Key(Container => This.Pending_Route,
                                                Position  => C);

               -- i->second()
               Liste_Route : Int64_Set :=
                 Int64_Pending_Route_Matrix.Element(Container => THis.Pending_Route,
                                                    Position  => C);
            begin

               for Id_Request in Liste_Route loop

                  if (Int64_Route_Plan_Responses_Maps.Contains(Container => This.Route_Plan_Responses,
                                                               Key       => Id_Request))
                  then

                     Is_Fulfilled := False;
                     Break;
                  end if;
               end loop;


               Int64_Pending_Route_Matrix.Next(Container => THis.Pending_Route,
                                               Position  => C);
               if (Is_Fulfilled) then

                  This.Send_Route_Reponse(RouteKey => Route_Id);
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
               Is_Fulfilled :Boolean := True;

               -- k->first()
               Req_Id : Int64_Pending_Auto_Req_Matrix.Key(Container => THis.Pending_Auto_Req,
                                                          Position  => I);

               -- k->second()
               All_Response_ID : Int64_Set := Int64_Pending_Auto_Req_Matrix.Element(Container => This.Pending_Auto_Req,
                                                                                    Position  => I);
            begin

               for Response_ID : constant Int64 in  All_Response_ID loop

                  if Int64_Route_Plan_Maps.Find(Container => THis.Route_Plan,
                                                Key       => Response_ID)
                  then
                     Is_Fulfilled := False;
                     Break;
                  end if;
               end loop;


               -- k++;
               Int64_Pending_Auto_Req_Matrix.Next(Container => THis.Pending_Auto_Req,
                                                  Position  => I);

               --   if (isFulfilled)

               if Is_Fulfilled then

                  -- SendMatrix(k->first);
                  This.Send_Matrix(Req_Id);

                  -- // finished with this automation request, discard
                  -- m_uniqueAutomationRequests.erase(k->first);
                  -- k = m_pendingAutoReq.erase(k);
                  Int64_Unique_Automation_Request_Maps.Delete(Container => This.Unique_Automation_Request,
                                                              Key       => Req_Id);
               end if;
            end;

         end loop;

      end Check_All_Route_Plans;



   end UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service;
