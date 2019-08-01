with UxAS.Messages.Lmcptask.TaskOptionCost; use UxAS.Messages.Lmcptask.TaskOptionCost;

package UxAS.Messages.Lmcptask.TaskOptionCost.SPARK_Boundary with SPARK_Mode is
   
   type My_TaskOptionCost is private with 
   Default_Initial_Condition => True;
      
   function Get_DestinationTaskID
     (This : My_TaskOptionCost) return Int64 with 
     Global => null;
   
   function Get_DestinationTaskOption
     (This : My_TaskOptionCost) return Int64 with 
     Global => null;
   
   function Get_IntialTaskID
     (This : My_TaskOptionCost) return Int64 with 
     Global => null;
       
   function Get_IntialTaskOption
     (This : My_TaskOptionCost) return Int64 with 
     Global => null;
              
   function Get_TimeToGo
     (This : My_TaskOptionCost) return Int64 with 
     Global => null;
   
   function Get_VehicleID
     (This : My_TaskOptionCost) return Int64 with 
     Global => null;
       
   
   function Same_Requests (X, Y : My_TaskOptionCost) return Boolean is
     ( Get_DestinationTaskID (X) = Get_DestinationTaskID (Y) 
      and Get_IntialTaskID   (X) = Get_IntialTaskID (Y) 
      and Get_DestinationTaskOption (X) = Get_DestinationTaskOption (Y) 
      and Get_IntialTaskOption (X) = Get_IntialTaskOption (Y) 
      and Get_TimeToGo  (X) = Get_TimeToGo  (Y) 
      and Get_VehicleID (X) = Get_VehicleID (Y));
   
   
   pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
   
       
   overriding function "=" (X, Y : My_TaskOptionCost) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
       
       
   procedure Set_DestinationTaskID
     (This : in out My_TaskOptionCost;
      DestinationTaskID  : Int64 ) with
     Global => null,
     Post => Get_DestinationTaskID (This) = DestinationTaskID
     and Get_DestinationTaskOption (This) = Get_DestinationTaskOption (This'Old) 
     and Get_IntialTaskOption  (This) = Get_IntialTaskOption  (This'Old) 
     and Get_IntialTaskID (This) = Get_IntialTaskID (This'Old) 
     and Get_TimeToGo  (This) = Get_TimeToGo  (This'Old) 
     and Get_VehicleID (This) = Get_VehicleID (This'Old) ;
       
   procedure Set_DestinationTaskOption
     (This : in out My_TaskOptionCost;
      DestinationTaskOption  : Int64 ) with
     Global => null,
     Post => Get_DestinationTaskOption (This) = DestinationTaskOption 
     and Get_DestinationTaskID (This) = Get_DestinationTaskID (This'Old) 
     and Get_IntialTaskOption  (This) = Get_IntialTaskOption  (This'Old) 
     and Get_IntialTaskID (This) = Get_IntialTaskID (This'Old) 
     and Get_TimeToGo  (This) = Get_TimeToGo  (This'Old) 
     and Get_VehicleID (This) = Get_VehicleID (This'Old);
       
   procedure Set_IntialTaskID
     (This : in out My_TaskOptionCost;
      IntialTaskID  : Int64 ) with
     Global => null,
     Post => Get_IntialTaskID (This) = IntialTaskID
     and Get_DestinationTaskOption (This) = Get_DestinationTaskOption (This'Old) 
     and Get_DestinationTaskID (This) = Get_DestinationTaskID (This'Old) 
     and Get_IntialTaskOption  (This) = Get_IntialTaskOption  (This'Old)
     and Get_TimeToGo  (This) = Get_TimeToGo  (This'Old) 
     and Get_VehicleID (This) = Get_VehicleID (This'Old) ;
       
   procedure Set_IntialTaskOption
     (This : in out My_TaskOptionCost;
      IntialTaskOption  : Int64 ) with
     Global => null,
     Post => Get_IntialTaskOption  (This) = IntialTaskOption
     and Get_DestinationTaskOption (This) = Get_DestinationTaskOption (This'Old) 
     and Get_DestinationTaskID (This) = Get_DestinationTaskID (This'Old) 
     and Get_IntialTaskID (This) = Get_IntialTaskID (This'Old) 
     and Get_TimeToGo  (This) = Get_TimeToGo  (This'Old) 
     and Get_VehicleID (This) = Get_VehicleID (This'Old) ;
   
   procedure Set_TimeToGo
     (This : in out My_TaskOptionCost;
      TimeToGo  : Int64 ) with
     Global => null,
     Post => Get_TimeToGo  (This) = TimeToGo
     and Get_DestinationTaskOption (This) = Get_DestinationTaskOption (This'Old) 
     and Get_DestinationTaskID (This) = Get_DestinationTaskID (This'Old) 
     and Get_IntialTaskOption  (This) = Get_IntialTaskOption  (This'Old) 
     and Get_IntialTaskID (This) = Get_IntialTaskID (This'Old) 
     and Get_VehicleID (This) = Get_VehicleID (This'Old) ;
   
      
   procedure Set_VehicleID
     (This : in out My_TaskOptionCost;
      VehicleID  : Int64 ) with
     Global => null,
     Post => Get_VehicleID (This) = VehicleID
     and Get_DestinationTaskOption (This) = Get_DestinationTaskOption (This'Old) 
     and Get_DestinationTaskID (This) = Get_DestinationTaskID (This'Old) 
     and Get_IntialTaskOption  (This) = Get_IntialTaskOption  (This'Old) 
     and Get_IntialTaskID (This) = Get_IntialTaskID (This'Old) 
     and Get_TimeToGo  (This) = Get_TimeToGo  (This'Old);
   
   function Unwrap (This : My_TaskOptionCost) return TaskOptionCost with 
     Global => null,
     Inline,
     SPARK_Mode => Off; 
   
   function Wrap (This : TaskOptionCost) return My_TaskOptionCost with 
     Global => null,
     Inline,
     SPARK_Mode => Off; 
   
   
private 
   pragma SPARK_Mode (Off);
   
   type My_TaskOptionCost is record 
      Content : TaskOptionCost;
   end record;
       
   function Get_DestinationTaskID
     (This : My_TaskOptionCost) return Int64 is
     (This.Content.GetDestinationTaskID);
       
   function Get_DestinationTaskOption
     (This : My_TaskOptionCost) return Int64 is
     (This.Content.GetDestinationTaskOption);
   
      
   function Get_IntialTaskID
     (This : My_TaskOptionCost) return Int64 is
     (This.Content.GetIntialTaskID);
           
   function Get_IntialTaskOption
     (This : My_TaskOptionCost) return Int64 is
     (This.Content.GetIntialTaskOption);
   
   function Get_TimeToGo
     (This : My_TaskOptionCost) return Int64 is
     (This.Content.GetTimeToGo);
   
   function Get_VehicleID
     (This : My_TaskOptionCost) return Int64 is
     (This.Content.GetVehicleID);
   
   
       
   overriding function "=" (X, Y : My_TaskOptionCost) return Boolean is
     (X.Content =Y.Content);
   function Unwrap (This : My_TaskOptionCost) return TaskOptionCost is
     (This.Content);

   function Wrap (This : TaskOptionCost) return My_TaskOptionCost is
     (Content => This);
       

end UxAS.Messages.Lmcptask.TAskOptionCost.SPARK_Boundary;
