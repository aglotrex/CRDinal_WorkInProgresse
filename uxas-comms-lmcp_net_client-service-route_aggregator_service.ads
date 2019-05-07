
--  see OpenUxAS\src\Services\RouteAggregator.h

with DOM.Core;
with AFRL.CMASI.LmcpTask;
with UxAS.Messages.LmcpTask;
with UxAS.Messages.LmcpTask.UniqueAutomationResponse;

with Afrl.Cmasi.EntityState; use Afrl.Cmasi.EntityState;
with Afrl.Cmasi.EntityConfiguration; use Afrl.Cmasi.EntityConfiguration;
with Uxas.Messages.Lmcptask.UniqueAutomationRequest; use Uxas.Messages.Lmcptask.UniqueAutomationRequest;
with Uxas.Messages.Lmcptask.TaskPlanOptions; use Uxas.Messages.Lmcptask.TaskPlanOptions;
with Uxas.Messages.Route.RoutePlan; use Uxas.Messages.Route.RoutePlan;
with Uxas.Messages.Route.RoutePlanResponse; use Uxas.Messages.Route.RoutePlanResponse;
with Uxas.Messages.Route.RoutePlanRequest; use Uxas.Messages.Route.RoutePlanRequest;

with Uxas.Messages.Route.RouteRequest; use Uxas.Messages.Route.RouteRequest;

with Afrl.Cmasi.EntityState.SPARK_Boundary; use Afrl.Cmasi.EntityState.SPARK_Boundary;
with Afrl.Cmasi.EntityConfiguration.SPARK_Boundary; use Afrl.Cmasi.EntityConfiguration.SPARK_Boundary;
with UxAS.Messages.Lmcptask.UniqueAutomationRequest.SPARK_Boundary; use UxAS.Messages.Lmcptask.UniqueAutomationRequest.SPARK_Boundary;
with UxAS.Messages.Lmcptask.TaskPlanOptions; use UxAS.Messages.Lmcptask.TaskPlanOptions;
with UxAS.Messages.Route.RoutePlanResponse; use UxAS.Messages.Route.RoutePlanResponse;



with Ada.Containers.Formal_Hashed_Maps;
with Ada.Containers.Formal_Doubly_Linked_Lists;
with AFRL.CMASI.OperatingRegion.SPARK_Boundary; use AFRL.CMASI.OperatingRegion.SPARK_Boundary;
with Afrl.Cmasi.LmcpTask.SPARK_Boundary;
with Common_Formal_Containers; use Common_Formal_Containers;



package UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service is



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

   -- must be manually called to "construct" the object

   procedure Construct (This : in out Route_Aggregator_Service);
   --  the ctor

private


   -- static
   -- ServiceBase::CreationRegistrar<RouteAggregatorService> s_registrar;
   -- See the pactakge body executable part


   use UxAS.Messages.LmcpTask.UniqueAutomationRequest;
   use UxAS.Messages.LmcpTask.UniqueAutomationResponse;


   type AggregatorTaskOptionPair is record
      VehicleId      : Int64 := 0;
      PrevTaskId     : Int64 := 0;
      PrevTaskOption : Int64 := 0;
      TaskId         : Int64 := 0;
      TaskOption     : Int64 := 0;
   end record;

   overriding
   procedure Configure(This     : in out Route_Aggregator_Service;
                       XML_Node : DoM.Core.Element;
                       Result  : out Boolean);

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
      Returned_Route_Plan : RoutePlan_Acc;
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

      --  std::unordered_map<int64_t, std::shared_ptr<afrl::cmasi::EntityState> > m_entityStates;
      Entity_State : Entity_State_Map;

      --  std::unordered_map<int64_t, std::shared_ptr<afrl::cmasi::EntityConfiguration> > m_entityConfigurations;
      Entity_Configuration : Entity_Configuration_Map;




      --   std::unordered_set<int64_t> m_airVehicles;
      Air_Vehicules : Int64_Set;

      --   std::unordered_set<int64_t> m_groundVehicles;
      Ground_Vehicles : Int64_Set;

      --   std::unordered_set<int64_t> m_surfaceVehicles;
      Surface_Vehicles : Int64_Set;

      -- int64_t m_autoRequestId{1}
      -- std::unordered_map<int64_t, std::shared_ptr<uxas::messages::task::UniqueAutomationRequest> > m_uniqueAutomationRequests;
      Auto_Request_Id : Int64 := 1;
      Unique_Automation_Request : Unique_Automation_Request_Map;

      -- std::unordered_map<int64_t, std::shared_ptr<uxas::messages::task::TaskPlanOptions> > m_taskOptions;
      Task_Plan_Options : Task_Plan_Options_Map;

      -- int64_t m_routeId{1000000}
      Route_Id : Int64 := 1000000;

      --  //                route id,    plan response id                 returned route plan
      --  std::unordered_map<int64_t, std::pair<int64_t, std::shared_ptr<uxas::messages::route::RoutePlan> > > m_routePlans;
      Route_Plan : Pair_Int64_Route_Plan_Map;

      --  std::unordered_map<int64_t, std::unordered_set<int64_t> > m_pendingAutoReq;
      Pending_Auto_Req : Pending_Auto_Req_Matrix;

      --  std::unordered_map<int64_t, std::shared_ptr<AggregatorTaskOptionPair> > m_routeTaskPairing;
      Route_Task_Pairing : Aggregator_Task_Option_Pair_Map;

      --  int64_t m_routeRequestId{1};
      --  std::unordered_map<int64_t, std::shared_ptr<uxas::messages::route::RoutePlanResponse> > m_routePlanResponses;
      Route_Request_ID : Int64 := 1;
      Route_Plan_Responses : Route_Plan_Responses_Map;

      --  std::unordered_map<int64_t, std::unordered_set<int64_t> > m_pendingRoute;
      Pending_Route : Pending_Route_Matrix;
   end record;



end UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service;
