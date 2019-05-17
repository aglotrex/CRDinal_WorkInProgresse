with UxAS.Messages.Route.RouteRequest.SPARK_Boundary; use UxAS.Messages.Route.RouteRequest.SPARK_Boundary;


with UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service; use UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service;
with UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary; use UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary;


private
package UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK with SPARK_Mode is


   function Check_Route_Plan    (This : Route_Aggregator_Service) return Boolean with Ghost;
   function Check_Entity_State  (This : Route_Aggregator_Service) return Boolean with Ghost;
   function Check_Pending_Route (This : Route_Aggregator_Service) return Boolean with Ghost;
   function Check_Task_Plan_Options    (This : Route_Aggregator_Service) return Boolean with Ghost;
   function Check_Route_Plan_Response  (This : Route_Aggregator_Service) return Boolean with Ghost;
   function Check_Entity_Configuration (This : Route_Aggregator_Service) return Boolean with Ghost;
   function Check_List_Pending_Request (This : Route_Aggregator_Service) return Boolean with Ghost;
   function Check_Unique_Automation_Request (This : Route_Aggregator_Service) return Boolean with Ghost;

   function Check_Send_Valid (This : Route_Aggregator_Service;
                              Route_Plan_Request : Int64_Set) return Boolean with Ghost;

   function All_Requests_Valid
     (This : Route_Aggregator_Service) return Boolean is
     (Check_Pending_Route    (This)
      and Check_Route_Plan   (This)
      and Check_Entity_State (This)
      and Check_Task_Plan_Options    (This)
      and Check_Route_Plan_Response  (This)
      and Check_Entity_Configuration (This)
      and Check_List_Pending_Request (This)
      and Check_Unique_Automation_Request (This))with Ghost;


   use all type Unique_Automation_Request_Map;
   procedure Build_Matrix_Requests (This  : in out Route_Aggregator_Service;
                                    ReqID : in Int64;
                                    Areq  : in My_UniqueAutomationRequest) with
     Pre => not Int64_Pending_Auto_Req_Matrix.Contains(This.Pending_Auto_Req,
                                                       ReqID),
     Post => This.Unique_Automation_Request'Old = This.Unique_Automation_Request;

   use all type Pending_Route_Matrix;
   -- void SendRouteResponse(int64_t);
   procedure Send_Route_Reponse (This     : in out Route_Aggregator_Service;
                                 RouteKey : Int64) with
     Pre =>
       Int64_Pending_Route_Matrix.Contains(This.Pending_Route,
                                           RouteKey)
     and then
       Check_Send_Valid(This               => This,
                        Route_Plan_Request => Element (This.Pending_Route, RouteKey)),
     Post => ( Int64_Pending_Route_Matrix.Contains(This.Pending_Route,
               RouteKey)
               and This.Pending_Route = This.Pending_Route'Old);



   -- void CheckAllRoutePlans();
   procedure Check_All_Route_Plans (This : in out Route_Aggregator_Service);


   --  void CheckAllTaskOptionsReceived();
   procedure Check_All_Task_Option_Received (This : in out Route_Aggregator_Service);



   -- For each vehicle concerne by Route_Resquest generate a series of My_RoutePlanRequests (and send it in function of the vehicles types)
   --
   --
   -- void HandleRouteRequest(std::shared_ptr<uxas::messages::route::RouteRequest>);
   procedure Handle_Route_Request (This          : in out Route_Aggregator_Service;
                                   Route_Request : My_RouteRequest) with
     Pre =>Contains (Container => This.Pending_Route,
                     Key       => Get_RequestID (Route_Request)) ;


   -- void EuclideanPlan(std::shared_ptr<uxas::messages::route::RoutePlanRequest>);
   procedure Euclidean_Plan (This               : in out Route_Aggregator_Service;
                             Route_Plan_Request : in My_RoutePlanRequest)
     with Pre => Int64_Route_Plan_Responses_Maps.Contains (This.Route_Plan_Responses,
                                                           Get_RequestID (Route_Plan_Request));

   --  Void SendMatrix(Int64_T);
   procedure Send_Matrix (This    : in out Route_Aggregator_Service;
                          AutoKey : Int64);


end  UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK ;
