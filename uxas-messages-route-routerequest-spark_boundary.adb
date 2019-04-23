with UxAS.Messages.Route.RouteConstraints.Spark_Boundary; use UxAS.Messages.Route.RouteConstraints.Spark_Boundary;

package body UxAS.Messages.Route.RouteRequest.SPARK_Boundary with SPARK_Mode => Off is

 
   ----------------------
   --  Get_Vehicle_ID  --
   ----------------------
   
   
   function Get_Vehicle_ID
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
   end Get_Vehicle_ID;
   
   
   -------------------------
   --  Get_RouteRequests  --
   -------------------------
      
   function Get_RouteRequests
     (Request : My_RouteRequest) return Vect_My_RouteConstraints_Acc
   is
      L : constant UxAS.Messages.Route.RouteRequest.Vect_RouteConstraints_Acc_Acc := 
        Request.Content.GetRouteRequests;
   begin
      return R : Vect_My_RouteConstraints_Acc do
         for E of L.all loop
            ApPend
              (Source   => R,
               New_Item => Wrap(This => E));
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
     (This : My_RouteRequest;
      Route_Constraints : My_RouteConstraints)
   is 
   begin
      This.Content.RouteRequests.Append(Route_Constraints);
   end Add_RouteConstraints;
   
   
         
end UxAS.Messages.Route.RouteRequest.SPARK_Boundary;
