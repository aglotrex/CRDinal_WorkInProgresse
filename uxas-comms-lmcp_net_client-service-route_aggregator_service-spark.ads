package UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK is



   -- void CheckAllRoutePlans();
   procedure Check_All_Route_Plans(This : in out Route_Aggregator_Service);

     --  void CheckAllTaskOptionsReceived();
   procedure Check_All_Task_Option_Received(This : in out Route_Aggregator_Service);

   -- void HandleRouteRequest(std::shared_ptr<uxas::messages::route::RouteRequest>);
   procedure Handle_Route_Request(This         : in out Route_Aggregator_Service;
                                  Route_Request : RouteRequest_Acc);




   -- void EuclideanPlan(std::shared_ptr<uxas::messages::route::RoutePlanRequest>);
   procedure Euclidean_Plan(This             : in out Route_Aggregator_Service;
                            Route_Plan_Request : RoutePlanRequest);


end  UxAS.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK ;
