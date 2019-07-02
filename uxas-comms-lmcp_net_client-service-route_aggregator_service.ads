
--  see OpenUxAS\src\Services\RouteAggregator.h

with DOM.Core;
with uxas.messages.lmcptask;

with afrl.cmasi.EntityState;                                        use afrl.cmasi.EntityState;
with afrl.cmasi.EntityConfiguration;                                use afrl.cmasi.EntityConfiguration;
with afrl.cmasi.EntityState.SPARK_Boundary;                         use afrl.cmasi.EntityState.SPARK_Boundary;
with afrl.cmasi.EntityConfiguration.SPARK_Boundary;                 use afrl.cmasi.EntityConfiguration.SPARK_Boundary;

with uxas.messages.lmcptask.UniqueAutomationRequest;                use uxas.messages.lmcptask.UniqueAutomationRequest;
with uxas.messages.lmcptask.TaskPlanOptions;
with uxas.messages.route.RoutePlan.SPARK_Boundary;                  use uxas.messages.route.RoutePlan.SPARK_Boundary;

with uxas.messages.route.RoutePlanResponse;                         use uxas.messages.route.RoutePlanResponse;
with uxas.messages.route.RoutePlanResponse.SPARK_Boundary;          use uxas.messages.route.RoutePlanResponse.SPARK_Boundary;

with uxas.messages.lmcptask.UniqueAutomationRequest.SPARK_Boundary; use uxas.messages.lmcptask.UniqueAutomationRequest.SPARK_Boundary;

with uxas.messages.lmcptask.TaskPlanOptions.SPARK_Boundary;         use uxas.messages.lmcptask.TaskPlanOptions.SPARK_Boundary;

with Ada.Containers.Formal_Hashed_Maps;
with Common_Formal_Containers;                                      use Common_Formal_Containers;

package uxas.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service is

   type Route_Aggregator_Service is new Service_Base with private;

   type Route_Aggregator_Service_Ref is access all Route_Aggregator_Service'Class;

   Type_Name : constant String := "RouteAggregatorService";

   Directory_Name : constant String := "";

   --  static const std::vector<std::string>
   --  s_registryServiceTypeNames()
   function Registry_Service_Type_Names return Service_Type_Names_List;

   --  static ServiceBase*
   --  create()
   function Create return Any_Service;

   --  must be manually called to "construct" the object

   procedure Construct (This : in out Route_Aggregator_Service);

private

   --  static
   --  ServiceBase::CreationRegistrar<RouteAggregatorService> s_registrar;
   --  See the pactakge body executable part

   type AggregatorTaskOptionPair is record
      VehicleId      : Int64 := 0;
      PrevTaskId     : Int64 := 0;
      PrevTaskOption : Int64 := 0;
      TaskId         : Int64 := 0;
      TaskOption     : Int64 := 0;
   end record;

   overriding
   procedure Configure (This    : in out Route_Aggregator_Service;
                       XML_Node : DOM.Core.Element;
                       Result   : out Boolean);

   overriding
   procedure Initialize
     (This   : in out Route_Aggregator_Service;
      Result : out Boolean);

   overriding
   procedure Process_Received_LMCP_Message
     (This             : in out Route_Aggregator_Service;
      Received_Message : not null Any_LMCP_Message;
      Result           : out Boolean);

   overriding
   procedure Process_Received_Serialized_LMCP_Message
     (This             : in out Route_Aggregator_Service;
      Received_Message : not null Any_Addressed_Attributed_Message;
      Result           : out Boolean);

   type Entity_State_Holder is record
      Content : My_EntityState;
   end record;
   package Int64_Entity_State_Maps is new Ada.Containers.Formal_Hashed_Maps
     (Key_Type     => Int64,
      Element_Type => Entity_State_Holder,
      Hash         => Int64_Hash);

   Entity_State_Max_Capacity : constant := 200; -- arbitrary

   subtype Entity_State_Map is Int64_Entity_State_Maps.Map
     (Entity_State_Max_Capacity,
      Int64_Entity_State_Maps.Default_Modulus (Entity_State_Max_Capacity));

   type Entity_Configuration_Holder is record
      Content : My_EntityConfiguration;
   end record;
   package Int64_Entity_Configuration_Maps is new Ada.Containers.Formal_Hashed_Maps
     (Key_Type     => Int64,
      Element_Type => Entity_Configuration_Holder,
      Hash         => Int64_Hash);

   Entity_Configuration_Max_Capacity : constant := 200; -- arbitrary

   subtype Entity_Configuration_Map is Int64_Entity_Configuration_Maps.Map
     (Entity_Configuration_Max_Capacity,
      Int64_Entity_Configuration_Maps.Default_Modulus (Entity_Configuration_Max_Capacity));

   type UniqueAutomationRequest_Handler is record
      Content : My_UniqueAutomationRequest;
   end record;

   package Int64_Unique_Automation_Request_Maps is new Ada.Containers.Formal_Hashed_Maps
     (Key_Type     => Int64,
      Element_Type => UniqueAutomationRequest_Handler,
      Hash         => Int64_Hash);

   Unique_Automation_Request_Max_Capacity : constant := 200; -- arbitrary

   subtype Unique_Automation_Request_Map is Int64_Unique_Automation_Request_Maps.Map
     (Unique_Automation_Request_Max_Capacity,
      Int64_Unique_Automation_Request_Maps.Default_Modulus (Unique_Automation_Request_Max_Capacity));

   type Task_Plan_Options_Holder is record
      Content : My_TaskPlanOptions;
   end record;
   package Int64_Task_Plan_Options_Maps is new Ada.Containers.Formal_Hashed_Maps
     (Key_Type     => Int64,
      Element_Type => Task_Plan_Options_Holder,
      Hash         => Int64_Hash);

   Task_Plan_Options_Max_Capacity : constant := 200; -- arbitrary

   subtype Task_Plan_Options_Map is Int64_Task_Plan_Options_Maps.Map
     (Task_Plan_Options_Max_Capacity,
      Int64_Task_Plan_Options_Maps.Default_Modulus (Task_Plan_Options_Max_Capacity));

   type Pair_Int64_Route_Plan is record
      Reponse_ID : Int64;
      Returned_Route_Plan : My_RoutePlan;
   end record;

   package Int64_Pair_Int64_Route_Plan_Maps is new Ada.Containers.Formal_Hashed_Maps
     (Key_Type     => Int64,
      Element_Type => Pair_Int64_Route_Plan,
      Hash         => Int64_Hash);

   Pair_Int64_Route_Plan_Max_Capacity : constant := 200; -- arbitrary

   subtype Pair_Int64_Route_Plan_Map is Int64_Pair_Int64_Route_Plan_Maps.Map
     (Pair_Int64_Route_Plan_Max_Capacity,
      Int64_Pair_Int64_Route_Plan_Maps.Default_Modulus (Pair_Int64_Route_Plan_Max_Capacity));

   package Int64_Pending_Auto_Req_Matrix is new Ada.Containers.Formal_Hashed_Maps
     (Key_Type     => Int64,
      Element_Type => Int64_Set,
      Hash         => Int64_Hash);

   Pending_Auto_Req_Max_Capacity : constant := 200; -- arbitrary

   subtype Pending_Auto_Req_Matrix is Int64_Pending_Auto_Req_Matrix.Map
     (Pending_Auto_Req_Max_Capacity,
      Int64_Pending_Auto_Req_Matrix.Default_Modulus (Pending_Auto_Req_Max_Capacity));

   package Int64_Aggregator_Task_Option_Pair_Maps is new Ada.Containers.Formal_Hashed_Maps
     (Key_Type     => Int64,
      Element_Type => AggregatorTaskOptionPair,
      Hash         => Int64_Hash);

   Aggregator_Task_Option_Pair_Max_Capacity : constant := 200; -- arbitrary

   subtype Aggregator_Task_Option_Pair_Map is Int64_Aggregator_Task_Option_Pair_Maps.Map
     (Aggregator_Task_Option_Pair_Max_Capacity,
      Int64_Aggregator_Task_Option_Pair_Maps.Default_Modulus (Aggregator_Task_Option_Pair_Max_Capacity));

   type Route_Plan_Responses_Holder is record
      Content : My_RoutePlanResponse;
   end record;

   package Int64_Route_Plan_Responses_Maps is new Ada.Containers.Formal_Hashed_Maps
     (Key_Type     => Int64,
      Element_Type => Route_Plan_Responses_Holder,
      Hash         => Int64_Hash);

   Route_Plan_Responses_Max_Capacity : constant := 200; -- arbitrary

   subtype Route_Plan_Responses_Map is Int64_Route_Plan_Responses_Maps.Map
     (Route_Plan_Responses_Max_Capacity,
      Int64_Route_Plan_Responses_Maps.Default_Modulus (Route_Plan_Responses_Max_Capacity));

   package Int64_Pending_Route_Matrix is new Ada.Containers.Formal_Hashed_Maps
     (Key_Type     => Int64,
      Element_Type => Int64_Set,
      Hash         => Int64_Hash);

   Pending_Route_Max_Capacity : constant := 200; -- arbitrary

   subtype Pending_Route_Matrix is Int64_Pending_Route_Matrix.Map
     (Pending_Route_Max_Capacity,
      Int64_Pending_Route_Matrix.Default_Modulus (Pending_Route_Max_Capacity));

   type Route_Aggregator_Service is new Service_Base with record

      Fast_Plan : Boolean := False;

      --  list of vheicles actual state in the system including position, speed, and fuel status.
      --  used to create routes and cost estimates from the associated vehicle position and heading to the task option start locations
      --  The Key is the vehicles ID describe by Entity_State
      --  the Vehicles ID is reference in Only one of the Type vehicles
      Entity_State : Entity_State_Map;

      --  No state change. Store to identify appropriate route planner by vehicle ID.
      --  The Key is the vehicles ID describe by Entity_Configuration
      --  the Vehicles ID is reference in Only one of the Type vehicles
      Entity_Configuration : Entity_Configuration_Map;

      --  List of All Vehicles ID who corresponds to Air Vehicules
      Air_Vehicules : Int64_Set;

      --  List of All Vehicles ID who corresponds to Ground Vehicles
      Ground_Vehicles : Int64_Set;

      --  List of All Vehicles ID who corresponds to Surface Vehicles
      Surface_Vehicles : Int64_Set;

      Auto_Request_Id : Int64 := 1;

      --  create checklist of expected task options
      --  Key is a unique ID generate (from at the reception of a new Request with Auto_Request_Id)
      Unique_Automation_Request : Unique_Automation_Request_Map;

      --  store suplement data related to task use for buiding matrix
      --  Primary message from *Tasks* that prescribe available start
      --  The Key is the Task_Plan_Option ID
      Task_Plan_Options : Task_Plan_Options_Map;

      --  // Starting ID for uniquely identifying route plan
      Route_Id : Int64 := 1000000;  -- // start outside of any task or waypoint id

      --  //                route id,    plan response id                 returned route plan
      --  std::unordered_map<int64_t, std::pair<int64_t, std::shared_ptr<uxas::messages::route::RoutePlan> > > m_routePlans;

      --  contain all complete Route calculation
      --  calculation are link to a request asking and end locations for each option as well as cost to complete the option.
      --  the Key of the pair is equal to the ID of ROute_Plan_ response (the second element of the pair)
      --  the response_ID (first element of the pair) correspond to a Route_Plan_Responses
      --
      --  Also  the response_ID reverence in Pending_Route
      --     OR The ROute ID reverence in Pending_Auto_Req and the are link to a AggregatorTaskOptionPair in Route_Task_Pairing
      Route_Plan : Pair_Int64_Route_Plan_Map;

      --  Matrix of requst ID to Route ID to fulffly for a matrix request
      --  Key is a Unique_automation Key
      --  content is a list of Unique Route ID (generated with acc Route_Id)
      --  all the ID referenced by this liste are key of Route_Task_Pairing
      Pending_Auto_Req : Pending_Auto_Req_Matrix;

      --  the Key is a unique route ID (generated with Route_Id)
      --  the contente agggreaget the information about the travel
      Route_Task_Pairing : Aggregator_Task_Option_Pair_Map;

      --  int64_t m_routeRequestId{1};
      Route_Request_ID : Int64 := 1;

      --  list evry fulfy of a single vehicle route plan request
      --  some a the request have being generated by Handeling request and are referenced in Pending_Route
      Route_Plan_Responses : Route_Plan_Responses_Map;

      --  Key repesente the Route_request ID
      --  and the content is a list of unique ID (generated with accumulator Route_Request_ID) that is asssociete with a Route calculation request
      Pending_Route : Pending_Route_Matrix;
   end record;
   --
   --      procedure XML_Write (this  : Route_Aggregator_Service;
   --                          S     : access Ada.Streams.Root_Stream_Type'Class;
   --                          Level : Natural)

end uxas.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service;
