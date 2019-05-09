package body UxAS.Messages.Route.RoutePlanResponse.SPARK_Boundary with SPARK_Mode => Off is

   ----------------------
   --  Set_ResponseID  --
   ----------------------
   
   procedure Set_ResponseID
     (This : in out My_RoutePlanResponse;
      ResponseID : Int64) 
   is
   begin
      This.Content.SetResponseID(ResponseID);
   end Set_ResponseID;
   
   ----------------------------
   --  Set_AssociatedTaskID  --
   ----------------------------
   
   procedure Set_AssociatedTaskID
     (This : in out My_RoutePlanResponse;
      AssociatedTaskID : Int64) 
   is
   begin
      This.Content.SetAssociatedTaskID(AssociatedTaskID);
   end Set_AssociatedTaskID;
   
   
   ---------------------
   --  Set_VehicleID  --
   ---------------------
    
   procedure Set_VehicleID
     (This : in out My_RoutePlanResponse;
      VehicleID : Int64) 
   is
   begin
      This.Content.SetVehicleID(VehicleID);
   end Set_VehicleID;
   
   ---------------------------
   --  Set_OperatingRegion  --
   ---------------------------
   
   procedure Set_OperatingRegion
     (This : in out My_RoutePlanResponse;
      OperatingRegion : Int64) 
   is
   begin
      This.Content.SetOperatingRegion(OperatingRegion);
   end Set_OperatingRegion;
 

end UxAS.Messages.Route.RoutePlanResponse.SPARK_Boundary;
