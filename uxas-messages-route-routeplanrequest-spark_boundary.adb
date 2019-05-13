package body UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary with SPARK_Mode => Off is

   -------------------------
   --  Get_RouteRequests  --
   -------------------------
   
   function Get_RouteRequests
     (This : My_RoutePlanRequest) return Vect_My_RouteConstraints 
   is 
      L : constant Uxas.Messages.Route.RoutePlanRequest.Vect_RouteConstraints_Acc_Acc :=
        This.Content.GetRouteRequests;
   begin
      return R : Vect_My_RouteConstraints do
         for E of L.all loop
            Vect_My_RouteConstraints_P.Append(Container => R,
                                              New_Item  => Wrap(This => E.all));
         end loop;
      end return;
   end Get_RouteRequests;
   
  
   ----------------------------
   --  Set_AssociatedTaskID  --
   ----------------------------
   
   procedure Set_AssociatedTaskID
     (This : in out My_RoutePlanRequest;
      AssociatedTaskID : Int64) 
   is 
   begin
      This.Content.SetAssociatedTaskID(AssociatedTaskID);
   end Set_AssociatedTaskID;
   
   -----------------------------
   --  Set_IsCostOnlyRequest  --
   -----------------------------
   procedure Set_IsCostOnlyRequest
     (This : in out My_RoutePlanRequest;
      IsCostOnlyRequest : Boolean) 
   is 
   begin
      This.Content.SetIsCostOnlyRequest (IsCostOnlyRequest);
   end Set_IsCostOnlyRequest;
   
   ---------------------------
   --  Set_OperatingRegion  --
   ---------------------------
   
   
   procedure Set_OperatingRegion
     (This : in out My_RoutePlanRequest;
      OperatingRegion : Int64) 
   is 
   begin
      This.Content.SetOperatingRegion (OperatingRegion);
   end Set_OperatingRegion;
   
   ---------------------
   --  Set_VehicleID  --
   ---------------------
   
   
   procedure Set_VehicleID
     (This : in out My_RoutePlanRequest;
      VehicleID : Int64) 
   is 
   begin
      This.Content.SetVehicleID (VehicleID);
   end Set_VehicleID;
   
   ---------------------
   --  Set_RequestID  --
   ---------------------
   
   procedure Set_RequestID
     (This : in out My_RoutePlanRequest;
      RequestID : Int64)
   is 
   begin
      This.Content.SetRequestID(RequestID);
   end Set_RequestID;
     
   ----------------------------
   --  Append_RouteRequests  --
   ----------------------------
   
   procedure Append_RouteRequests
     (This : in out My_RoutePlanRequest;
      RouteRequests : My_RouteConstraints)
   is
      RouteRequests_Acc : RouteConstraints_Acc;
      
   begin
      RouteRequests_Acc.all := UxAS.Messages.Route.RouteConstraints.SPARK_Boundary.Unwrap (RouteRequests);
      This.Content.GetRouteRequests.Append( RouteRequests_Acc );
   end Append_RouteRequests;
   
      
   

end UxAS.Messages.Route.RoutePlanRequest.SPARK_Boundary;
