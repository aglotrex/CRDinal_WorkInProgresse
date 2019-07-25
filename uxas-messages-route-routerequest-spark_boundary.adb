
package body UxAS.Messages.Route.RouteRequest.SPARK_Boundary with SPARK_Mode => Off is

 
   ---------------------
   --  Get_VehicleID  --
   ---------------------
   
   
   function Get_VehicleID
     (Request : My_RouteRequest) return Int64_Vect
   is
      L : constant Vect_Int64_Acc := Request.Content.GetVehicleID;
   begin
      return R : Int64_Vect do 
         for E of L.all loop
            Int64_Vects.Append (Container => R,
                                New_Item  => E);
         end loop;
      end return;
   end Get_VehicleID;
   
   
   -------------------------
   --  Get_RouteRequests  --
   -------------------------
      
   function Get_RouteRequests
     (Request : My_RouteRequest) return Vect_My_RouteConstraints
   is
      L : constant UxAS.Messages.Route.RouteRequest.Vect_RouteConstraints_Acc_Acc := 
        Request.Content.GetRouteRequests;
   begin
      return R : Vect_My_RouteConstraints do
         for E of L.all loop
            Vect_My_RouteConstraints_P.Append(Container => R,
                                              New_Item  => Wrap(This => E.all));
         end loop;
      end return;
   end Get_RouteRequests;
   
   ---------------------
   --  Set_RequestID  --
   ---------------------
   
   procedure Set_RequestID 
     (This : in out My_RouteRequest;
      RequestID : Int64)
   is 
   begin
      This.Content.SetRequestID(RequestID);
   end Set_RequestID;
      
   
   ----------------------------
   --  Set_AssociatedTaskID  --
   ----------------------------
   
   procedure Set_AssociatedTaskID 
     (This : in out My_RouteRequest;
      AssociatedTaskID : Int64)
   is
   begin
      This.Content.SetAssociatedTaskID(AssociatedTaskID);
   end Set_AssociatedTaskID;
   
     
   ---------------------------
   --  Set_OperatingRegion  --
   ---------------------------
     
   procedure Set_OperatingRegion
     (This : in out My_RouteRequest;
      OperatingRegion : Int64)
   is 
   begin
      This.Content.SetOperatingRegion(OperatingRegion);
   end Set_OperatingRegion;
   
   procedure Add_RouteConstraints 
     (This : in out My_RouteRequest;
      Route_Constraints : in My_RouteConstraints)
   is 
      Pointer : constant RouteConstraints_Acc := new RouteConstraints.RouteConstraints;
   begin
      Pointer.all := Unwrap(Route_Constraints);
      Vect_RouteConstraints_Acc.Append (Container => This.Content.RouteRequests.all,
                                        New_Item  => Pointer);
   end Add_RouteConstraints;
   
   -----------------------------
   --  Set_IsCostOnlyRequest  --
   -----------------------------
        
   procedure Set_IsCostOnlyRequest
     (This : in out My_RouteRequest;
      IsCostOnlyRequest : Boolean)
   is
   begin
      This.Content.SetIsCostOnlyRequest(IsCostOnlyRequest);
   end Set_IsCostOnlyRequest;
   
   
   
   ----------------------
   --  Add_VehiclesID  --
   ----------------------
    
   procedure Add_VehiclesID
     (This : in out My_RouteRequest;
      VehiclesID : Int64) 
   is
   begin
      Vect_Int64.Append (Container => This.Content.GetVehicleID.all,
                         New_Item  => VehiclesID);
   end Add_VehiclesID;
   
   
   
         
end UxAS.Messages.Route.RouteRequest.SPARK_Boundary;
