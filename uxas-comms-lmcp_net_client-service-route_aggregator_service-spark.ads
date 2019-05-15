with UxAS.Messages.Route.RouteRequest.SPARK_Boundary; use UxAS.Messages.Route.RouteRequest.SPARK_Boundary;


with UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service; use UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service;
with UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary; use UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary;
with Ada.Containers.Formal_Vectors;


private
package UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK with SPARK_Mode is

   use Int64_Pending_Route_Matrix;
   function All_Requests_Valid
     (This : Route_Aggregator_Service) return Boolean is (True)
     with Ghost;



   procedure Build_Matrix_Requests (This  : in out Route_Aggregator_Service;
                                    ReqID : in Int64;
                                    Areq  : in My_UniqueAutomationRequest) with
     Pre => Int64_Pending_Auto_Req_Matrix.Contains(This.Pending_Auto_Req,
                                                   ReqID);

   -- void SendRouteResponse(int64_t);
   procedure Send_Route_Reponse (This     : in out Route_Aggregator_Service;
                                 RouteKey : Int64) with
     Pre => Int64_Unique_Automation_Request_Maps.Contains(THis.Unique_Automation_Request,
                                                          RouteKey)
     and Int64_Pending_Auto_Req_Matrix.Contains(This.Pending_Auto_Req,
                                                RouteKey);


   -- void CheckAllRoutePlans();
   procedure Check_All_Route_Plans (This : in out Route_Aggregator_Service);


   --  void CheckAllTaskOptionsReceived();
   procedure Check_All_Task_Option_Received (This : in out Route_Aggregator_Service);


   -- void HandleRouteRequest(std::shared_ptr<uxas::messages::route::RouteRequest>);
   procedure Handle_Route_Request (This          : in out Route_Aggregator_Service;
                                   Route_Request : My_RouteRequest);


   -- void EuclideanPlan(std::shared_ptr<uxas::messages::route::RoutePlanRequest>);
   procedure Euclidean_Plan (This               : in out Route_Aggregator_Service;
                             Route_Plan_Request : in My_RoutePlanRequest);

   --  Void SendMatrix(Int64_T);
   procedure Send_Matrix (This    : in out Route_Aggregator_Service;
                          AutoKey : Int64);


end  UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK ;
