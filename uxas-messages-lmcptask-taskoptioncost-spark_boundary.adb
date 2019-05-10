package body UxAS.Messages.Lmcptask.TAskOptionCost.SPARK_Boundary with SPARK_Mode => Off is

   -----------------------------
   --  Set_DestinationTaskID  --
   -----------------------------
      
   procedure Set_DestinationTaskID
     (This : in out My_TaskOptionCost;
      DestinationTaskID  : Int64 )
   is
   begin
      This.Content.SetDestinationTaskID(DestinationTaskID);
   end Set_DestinationTaskID;
   
   ---------------------------------
   --  Set_DestinationTaskOption  --
   ---------------------------------
          
   procedure Set_DestinationTaskOption
     (This : in out My_TaskOptionCost;
      DestinationTaskOption  : Int64 ) 
   is 
   begin
      This.Content.SetDestinationTaskOption(DestinationTaskOption);
   end Set_DestinationTaskOption;
       
   ------------------------
   --  Set_IntialTaskID  --
   ------------------------
      
   procedure Set_IntialTaskID
     (This : in out My_TaskOptionCost;
      IntialTaskID  : Int64 )
   is 
   begin
      THis.Content.SetIntialTaskID(IntialTaskID);
   end Set_IntialTaskID;
   
   ----------------------------
   --  Set_IntialTaskOption  --
   ----------------------------
          
   procedure Set_IntialTaskOption
     (This : in out My_TaskOptionCost;
      IntialTaskOption  : Int64 )
   is 
   begin
      This.Content.SetIntialTaskOption(IntialTaskOption);
   end Set_IntialTaskOption;
   
   --------------------
   --  Set_TimeToGo  --
   --------------------
      
   procedure Set_TimeToGo
     (This : in out My_TaskOptionCost;
      TimeToGo  : Int64 ) 
   is
   begin
      This.Content.SetTimeToGo(TimeToGo);
   end Set_TimeToGo;
   
   ---------------------
   --  Set_VehicleID  --
   ---------------------
      
   procedure Set_VehicleID
     (This : in out My_TaskOptionCost;
      VehicleID  : Int64 ) 
   is 
   begin
      This.Content.SetVehicleID(VehicleID);
   end Set_VehicleID;
   

end UxAS.Messages.Lmcptask.TAskOptionCost.SPARK_Boundary;
