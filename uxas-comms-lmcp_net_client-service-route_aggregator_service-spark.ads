
with Uxas.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service; use Uxas.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service;
with Uxas.Messages.Route.RoutePlan;                               use Uxas.Messages.Route.RoutePlan;
with Uxas.Messages.Route.RouteRequest.SPARK_Boundary;             use Uxas.Messages.Route.RouteRequest.SPARK_Boundary;
with UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Vects;   use UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Vects;
with UxAS.Messages.Route.RouteConstraints.SPARK_Boundary;         use UxAS.Messages.Route.RouteConstraints.SPARK_Boundary;
private
package Uxas.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK with SPARK_Mode is

   use all type Vect_My_RouteConstraints;
   use all type Aggregator_Task_Option_Pair_Map;
   use all type Pair_Int64_Route_Plan_Map;
   use all type Route_Plan_Responses_Map;
   use all type Entity_Configuration_Map;
   use all type Pending_Auto_Req_Matrix;
   use all type Pending_Route_Matrix;
   use all type Entity_State_Map;
   use all type Int64_Set;
   use all type Int64_Vect;
   use all type Unique_Automation_Request_Map;

   use all type Task_Plan_Options_Map;
   ------------------------------------------------
   -- Check of Route_Aggregator_Service Validity --
   ------------------------------------------------


   function Check_Route_Plan_Sub (Route_Plan_Pair      : Pair_Int64_Route_Plan;
                                  Route_Plan_Responses : Route_Plan_Responses_Map;
                                  Pending_Auto_Req     : Pending_Auto_Req_Matrix;
                                  Pending_Route        : Pending_Route_Matrix;
                                  Key                  : Int64) return Boolean is
     (Key = Get_RouteID (Route_Plan_Pair.Returned_Route_Plan)
      and ( Contains (Route_Plan_Responses, Route_Plan_Pair.Reponse_ID)
           and then Contains (Get_ID_From_RouteResponses (Element (Route_Plan_Responses, Route_Plan_Pair.Reponse_ID).Content), Key))
      and ((for Some Cursor in Pending_Auto_Req
            => Contains (Element (Pending_Auto_Req, Cursor), Key))
           or
             (for Some Cursor in Pending_Route
              => Contains (Element (Pending_Route, Cursor),  Route_Plan_Pair.Reponse_ID))))
     with Ghost;
   function Check_Route_Plan    (Route_Plan           : Pair_Int64_Route_Plan_Map;
                                 Route_Plan_Responses : Route_Plan_Responses_Map;
                                 Pending_Auto_Req     : Pending_Auto_Req_Matrix;
                                 Pending_Route        : Pending_Route_Matrix) return Boolean is
     (for all Cursor in Route_Plan
      => Check_Route_Plan_Sub (Element (Route_Plan, Cursor), Route_Plan_Responses, Pending_Auto_Req, Pending_Route, Key (Route_Plan, Cursor)))
     with Ghost;

   function Check_Task_Plan_Options    (Task_Plan_Options : Task_Plan_Options_Map) return Boolean is
     (for all Cursor in Task_Plan_Options
      => Key (Task_Plan_Options, Cursor) = Get_TaskID (Element (Task_Plan_Options,
                                                                Cursor).Content))
     with Ghost;
   function Check_Route_Plan_Response_Sub (Route_Plan_Response : My_RoutePlanResponse;
                                           Key                 : Int64) return Boolean is
     (Key = Get_ResponseID (Route_Plan_Response)) with Ghost;

   function Check_Route_Plan_Response  (Route_Plan_Responses : Route_Plan_Responses_Map) return Boolean is
     (for all Cursor in Route_Plan_Responses
      => (Check_Route_Plan_Response_Sub (Route_Plan_Response => Element (Route_Plan_Responses, Cursor).Content,
                                         Key                 => Key     (Route_Plan_Responses, Cursor))))
       with Ghost;


   function Check_Unique_Automation_Request (Unique_Automation_Request : Unique_Automation_Request_Map;
                                             Auto_Request_Id : Int64) return Boolean is
     (for all Cursor in Unique_Automation_Request
      => Key (Unique_Automation_Request, Cursor) < Auto_Request_Id)
       with Ghost;

   function Check_Entity_State  (Entity_State     : Entity_State_Map;
                                 Air_Vehicules    : Int64_Set;
                                 Ground_Vehicles  : Int64_Set;
                                 Surface_Vehicles : Int64_Set) return Boolean is
     (for all Cursor in Entity_State
      => ( -- check ID value
          Key (Entity_State, Cursor) = Get_ID (Element (Entity_State,
                                                        Cursor).Content)
          and
          --  check type identification
            (Contains (Air_Vehicules, Key (Entity_State, Cursor))
             xor
               Contains (Ground_Vehicles, Key (Entity_State, Cursor))
             xor
               Contains (Surface_Vehicles, Key (Entity_State, Cursor)))))
       with Ghost;

   function Check_Type_Vehicles (Air_Vehicules        : Int64_Set;
                                 Ground_Vehicles      : Int64_Set;
                                 Surface_Vehicles     : Int64_Set;
                                 Entity_State         : Entity_State_Map;
                                 Entity_Configuration : Entity_Configuration_Map) return Boolean is
     (for all Vehicle_ID in Int64'Range
      => (
          if  (Contains (Air_Vehicules, Vehicle_ID)
               or Contains (Air_Vehicules, Vehicle_ID)
               or Contains (Surface_Vehicles, Vehicle_ID))

          then
          -- check the vhehicles ID come from
            (   Contains (Entity_Configuration, Vehicle_ID)
             or Contains (Entity_State,         Vehicle_ID))
            -- check the fact a vehicles can't be refernce in two categorie
          and then
            (Contains     (Air_Vehicules,    Vehicle_ID)
             xor Contains (Ground_Vehicles,  Vehicle_ID)
             xor Contains (Surface_Vehicles, Vehicle_ID)))) with Ghost;

   function Check_Entity_Configuration (Entity_Configuration : Entity_Configuration_Map;
                                        Air_Vehicules        : Int64_Set;
                                        Ground_Vehicles      : Int64_Set;
                                        Surface_Vehicles     : Int64_Set) return Boolean is
     (for all Cursor in Entity_Configuration
      => ( -- check ID value
          Key (Entity_Configuration, Cursor) = Get_ID (Element (Entity_Configuration,
                                                                Cursor).Content)
          and
          --  check type identification
            (Contains (Air_Vehicules, Key (Entity_Configuration, Cursor))
             xor
               Contains (Ground_Vehicles,  Key (Entity_Configuration, Cursor))
             xor
               Contains (Surface_Vehicles, Key (Entity_Configuration, Cursor)))))
       with Ghost;

   function Check_Pending_Route (Pending_Route : Pending_Route_Matrix;
                                 Route_ID      : Int64) return Boolean is
     (for all Cursor_Request_ID_1 in Pending_Route
      => (for all Cursor_Route_Plan_1 in Element (Pending_Route, Cursor_Request_ID_1)
          => ( -- check ID value
              Route_ID > Element (Element (Pending_Route, Cursor_Request_ID_1), Cursor_Route_Plan_1)
              and

              -- check id unicity in other set
                (for all Cursor_Request_ID_2 in Pending_Route
                 => (if Key (Pending_Route, Cursor_Request_ID_1) /= Key (Pending_Route, Cursor_Request_ID_2) then
                       not Contains (Element (Pending_Route, Cursor_Request_ID_2),
                                     Element (Element (Pending_Route, Cursor_Request_ID_1), Cursor_Route_Plan_1)))))))
     with Ghost;





   function Check_List_Pending_Request (Pending_Auto_Req          : Pending_Auto_Req_Matrix;
                                        Unique_Automation_Request : Unique_Automation_Request_Map;
                                        Route_Task_Pairing        : Aggregator_Task_Option_Pair_Map;
                                        Route_ID                  : Int64) return Boolean is
     (for all Cursor_Request_ID_1 in Pending_Auto_Req
      => ( -- check id
          Contains (Unique_Automation_Request,
                    Key (Pending_Auto_Req, Cursor_Request_ID_1))
          and
            (for all Response_ID_1 of Element (Pending_Auto_Req, Cursor_Request_ID_1)
             => ( -- check valide ID
                 Route_ID > Response_ID_1
                 and
                 -- check it reference well a Route task pairing
                   Contains (Route_Task_Pairing,
                             Response_ID_1)
                 and
                 -- check ID unicity over other set
                   (for all Cursor_Request_ID_2 in Pending_Auto_Req
                    => (if Key (Pending_Auto_Req, Cursor_Request_ID_1) /= Key (Pending_Auto_Req, Cursor_Request_ID_2) then
                          not Contains (Element (Pending_Auto_Req, Cursor_Request_ID_2),
                                        Response_ID_1)))))))
     with Ghost;

   function Check_Route_Task_Pairing (Route_Task_Pairing : Aggregator_Task_Option_Pair_Map;
                                      Entity_State       : Entity_State_Map;
                                      Pending_Auto_Req   : Pending_Auto_Req_Matrix;
                                      Route_ID           : Int64) return Boolean is
     (for all Cursor in Route_Task_Pairing
      => ( -- check id
          Route_ID > Key (Route_Task_Pairing, Cursor)

          and
          -- check Vehicles ID of Aggregator
            Contains (Entity_State,
                      Element (Route_Task_Pairing, Cursor).VehicleId)
          and (for some Cursor_Pending in Pending_Auto_Req
               => Contains (Element (Pending_Auto_Req, Cursor_Pending), Key (Route_Task_Pairing, Cursor)))))
     with Ghost;

   function All_Requests_Valid
     (This : Route_Aggregator_Service) return Boolean is
     (Check_Route_Plan (This.Route_Plan, This.Route_Plan_Responses, This.Pending_Auto_Req, This.Pending_Route)
      and then Check_Entity_State  (This.Entity_State, This.Air_Vehicules, This.Ground_Vehicles, This.Surface_Vehicles)
      and then Check_Pending_Route (This.Pending_Route, This.Route_Id)
      and then Check_Type_Vehicles (This.Air_Vehicules, This.Ground_Vehicles, This.Surface_Vehicles, This.Entity_State, This.Entity_Configuration)
      and then Check_Task_Plan_Options    (This.Task_Plan_Options)
      and then Check_Route_Task_Pairing   (This.Route_Task_Pairing, This.Entity_State, This.Pending_Auto_Req, This.Route_Request_ID)
      and then Check_Route_Plan_Response  (This.Route_Plan_Responses)
      and then Check_Entity_Configuration (This.Entity_Configuration, This.Air_Vehicules, This.Ground_Vehicles, This.Surface_Vehicles)
      and then Check_List_Pending_Request (This.Pending_Auto_Req, This.Unique_Automation_Request, This.Route_Task_Pairing, This.Route_Id)
      and then Check_Unique_Automation_Request (This.Unique_Automation_Request, This.Auto_Request_Id)) with Ghost;

   -------------------------------------------------
   -- Check of Route_Aggregator_Service evolution --
   -------------------------------------------------

   --     function Check_Same_Entity_State
   --       (X, Y : Entity_State_Map) return Boolean is
   --       (Int64_Entity_State_Maps.Formal_Model.M.Same_Keys
   --          (Int64_Entity_State_Maps.Formal_Model.Model (X),
   --           Int64_Entity_State_Maps.Formal_Model.Model (Y))
   --        and then (for all C of X
   --                  => Same_Requests (Element (X, C).Content, Element (Y, C).Content)))
   --       with Ghost;
   --     procedure Lemma_Check_Same_Entity_State_Identity      (This    : in Entity_State_Map ) with Global => null,
   --       Post => Check_Same_Entity_State(This,This);
   --     procedure Lemma_Check_Same_Entity_State_Commutativity (X, Y    : in Entity_State_Map ) with Global => null,
   --       Pre => Check_Same_Entity_State(X,Y), Post => Check_Same_Entity_State(Y,X);
   --     procedure Lemma_Check_Same_Entity_State_Associativity (X, Y, Z : in Entity_State_Map ) with Global => null,
   --       Pre => Check_Same_Entity_State(X,Y) nd Check_Same_Entity_State(Y,Z),  Post => Check_Same_Entity_State(X,Z);

   --
   --     function Check_Same_Entity_Configuration
   --       (X, Y : Entity_Configuration_Map) return Boolean is
   --       (Int64_Entity_Configuration_Maps.Formal_Model.M.Same_Keys
   --          (Int64_Entity_Configuration_Maps.Formal_Model.Model (X),
   --           Int64_Entity_Configuration_Maps.Formal_Model.Model (Y))
   --        and then (for all C of X
   --                  => Same_Requests (Element (X, C).Content, Element (Y, C).Content )))
   --       with Ghost;
   --     function Check_Same_Unique_Automation_Request
   --       (X, Y : Unique_Automation_Request_Map) return Boolean is
   --       (Int64_Unique_Automation_Request_Maps.Formal_Model.M.Same_Keys
   --          (Int64_Unique_Automation_Request_Maps.Formal_Model.Model (X),
   --           Int64_Unique_Automation_Request_Maps.Formal_Model.Model (Y))
   --        and then (for all C of X
   --                  => Same_Requests (Element (X, C).Content, Element (Y, C).Content)))
   --       with Ghost;
   --     function Check_Same_Task_Plan_Options
   --       (X, Y : Task_Plan_Options_Map) return Boolean is
   --       (Int64_Task_Plan_Options_Maps.Formal_Model.M.Same_Keys
   --          (Int64_Task_Plan_Options_Maps.Formal_Model.Model (X),
   --           Int64_Task_Plan_Options_Maps.Formal_Model.Model (Y))
   --        and then (for all C of X
   --                  => Same_Requests (Element (X, C).Content, Element (Y, C).Content)))
   --       with Ghost;
   --     function Check_Same_Route_Plan
   --       (X, Y : Pair_Int64_Route_Plan_Map) return Boolean is
   --       (Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.M.Same_Keys
   --          (Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.Model (X),
   --           Int64_Pair_Int64_Route_Plan_Maps.Formal_Model.Model (Y))
   --        and then (for all C of X
   --                  => (Element (X, C).Reponse_ID   = Element (Y, C).Reponse_ID and
   --                        Same_Requests (Element (X, C).Returned_Route_Plan,Element (Y, C).Returned_Route_Plan))))
   --         with Ghost;
   --     function Check_Same_Pending_Auto_Req
   --       (X, Y : Pending_Auto_Req_Matrix) return Boolean is
   --       (Int64_Pending_Auto_Req_Matrix.Formal_Model.M.Same_Keys
   --          (Int64_Pending_Auto_Req_Matrix.Formal_Model.Model (X),
   --           Int64_Pending_Auto_Req_Matrix.Formal_Model.Model (Y))
   --        and then (for all C of X
   --                  => (Element (X, C) = Element (Y, C))))
   --       with Ghost;
   --     function Check_Same_Route_Task_Pairing
   --       (X, Y : Aggregator_Task_Option_Pair_Map) return Boolean is
   --       (Int64_Aggregator_Task_Option_Pair_Maps.Formal_Model.M.Same_Keys
   --          (Int64_Aggregator_Task_Option_Pair_Maps.Formal_Model.Model (X),
   --           Int64_Aggregator_Task_Option_Pair_Maps.Formal_Model.Model (Y))
   --        and then (for all C of X
   --                  => (Element (X, C).VehicleId = Element (Y, C).VehicleId
   --                      and Element (X, C).PrevTaskId = Element (Y, C).PrevTaskId
   --                      and Element (X, C).PrevTaskOption = Element (Y, C).PrevTaskOption
   --                      and Element (X, C).TaskId = Element (Y, C).TaskId
   --                      and Element (X, C).TaskOption = Element (Y, C).TaskOption)))
   --       with Ghost;
   --     function Check_Same_Route_Plan_Responses
   --       (X, Y : Route_Plan_Responses_Map) return Boolean is
   --       (Int64_Route_Plan_Responses_Maps.Formal_Model.M.Same_Keys
   --          (Int64_Route_Plan_Responses_Maps.Formal_Model.Model (X),
   --           Int64_Route_Plan_Responses_Maps.Formal_Model.Model (Y))
   --        and then (for all C of X
   --                  => Same_Requests (Element (X, C).Content, Element (Y, C).Content)))
   --       with Ghost;
   --     function Check_Same_Pending_Route
   --       (X, Y : Pending_Route_Matrix) return Boolean is
   --       (Int64_Pending_Route_Matrix.Formal_Model.M.Same_Keys
   --          (Int64_Pending_Route_Matrix.Formal_Model.Model (X),
   --           Int64_Pending_Route_Matrix.Formal_Model.Model (Y))
   --        and then (for all C of X
   --                  => (Element (X, C) = Element (Y, C))))
   --       with Ghost;
   --
   --     function Same_Route_Aggretor
   --       (X , Y : Route_Aggregator_Service) return Boolean is
   --       (X.Fast_Plan = Y.Fast_Plan
   --
   --        and Check_Same_Entity_State (X.Entity_State,Y.Entity_State)
   --
   --        and Check_Same_Entity_Configuration (X.Entity_Configuration, Y.Entity_Configuration)
   --
   --        and X.Ground_Vehicles = Y.Ground_Vehicles
   --        and X.Surface_Vehicles = Y.Surface_Vehicles
   --        and X.Air_Vehicules = Y.Air_Vehicules
   --
   --        and X.Auto_Request_Id = Y.Auto_Request_Id
   --
   --        and Check_Same_Unique_Automation_Request (X.Unique_Automation_Request, Y.Unique_Automation_Request)
   --
   --        and Check_Same_Task_Plan_Options (X.Task_Plan_Options, Y.Task_Plan_Options)
   --
   --        and X.Route_Id = Y.Route_Id
   --
   --        and Check_Same_Route_Plan (X.Route_Plan, Y.Route_Plan)
   --
   --        and Check_Same_Pending_Auto_Req (X.Pending_Auto_Req, Y.Pending_Auto_Req)
   --
   --        and Check_Same_Route_Task_Pairing (X.Route_Task_Pairing, Y.Route_Task_Pairing)
   --
   --        and X.Route_Request_ID = Y.Route_Request_ID
   --
   --        and Check_Same_Route_Plan_Responses (X.Route_Plan_Responses, Y.Route_Plan_Responses)
   --
   --        and Check_Same_Pending_Route (X.Pending_Route, Y.Pending_Route))  with Ghost;
   --     procedure Lemma_Same_Route_Aggregator_Validity
   --       (X, Y : in Route_Aggregator_Service ) with Global => null,
   --       Pre => Same_Route_Aggretor (X,Y) and All_Requests_Valid (X), Post => All_Requests_Valid (Y);
   --     procedure Lemma_Same_Route_Aggregator_Identity
   --       (This : in Route_Aggregator_Service ) with Post => Same_Route_Aggretor(This,This);
   --     procedure Lemma_Same_Route_Aggregator_Commutativity
   --       (X, Y : in Route_Aggregator_Service ) with Global => null,
   --       Pre => Same_Route_Aggretor(X,Y), Post => Same_Route_Aggretor(Y,X);
   --     procedure Lemma_Same_Route_Aggregator_Associativity
   --       (X, Y, Z : in Route_Aggregator_Service ) with Global => null,
   --       Pre => Same_Route_Aggretor(X,Y) and Same_Route_Aggretor(Y,Z),  Post => Same_Route_Aggretor(X,Z);

   --  verify if all route plan relatif to a route request a reeive
   --  and verify if all route plan ralatif to the matrix a receive
   procedure Check_All_Route_Plans (This : in out Route_Aggregator_Service) with
     Pre  => All_Requests_Valid (This),
     Post => All_Requests_Valid (This);

   --  verify if all the Task infomation relatif to a Unique Automation Request are receive
   procedure Check_All_Task_Option_Received (This : in out Route_Aggregator_Service) with
     Pre  => All_Requests_Valid (This),
     Post => All_Requests_Valid (This);

   --  For each vehicle target by Route_Resquest generate a corresponding My_RoutePlanRequests
   --   (and initiate calculationin function of the vehicles types)
   --
   --  Emit a number of *RoutePlanRequest* messages equal to the number of vehicles in the `VehicleID` field of the original *RouteRequest*
   procedure Handle_Route_Request (This          : in out Route_Aggregator_Service;
                                   Route_Request : My_RouteRequest) with
     Pre => All_Requests_Valid (This)
     and then Contains (Container => This.Pending_Route,
                        Key       => Get_RequestID (Route_Request))
     and then (for all Index in First_Index (Get_RouteRequests (Route_Request)) .. Last_Index (Get_RouteRequests (Route_Request))
               => not Contains (Container => This.Route_Plan,
                                Key       => UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Get_RouteID (Element (Container => Get_RouteRequests (Route_Request),
                                                                                                                       Index     => Index))))

     and then (if Is_Empty (Get_VehicleID (Route_Request))
                 then This.Route_Request_ID + Int64 ( Length ( This.Entity_State))               < Int64'Last
                   else This.Route_Request_ID + Int64 ( Length ( Get_VehicleID (Route_Request))) < Int64'Last),
     Post => All_Requests_Valid (This);

end  Uxas.Comms.LMCP_Net_Client.Service.Route_Aggregator_Service.SPARK;
