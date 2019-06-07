with Afrl.Cmasi.Location3D.SPARK_Boundary; use Afrl.Cmasi.Location3D.SPARK_Boundary;

package UxAS.Messages.Lmcptask.PlanningState.SPARK_Boundary with SPARK_Mode is
   
   type My_PlanningState is private with
     Default_Initial_Condition => True;

   function Get_EntityId
     (This : My_PlanningState) return Int64
     with Global => null;
   
   function Get_PlanningPosition
     (This : My_PlanningState) return My_Location3D_Any
     with Global => null;
   
   function Get_PlanningHeading
     (This : My_PlanningState) return Real32
     with Global => null;
   
   function Same_Requests (X,Y : My_PlanningState) return Boolean is
     (Get_EntityId (X) = Get_EntityId (Y)
      and Get_PlanningPosition (X) = Get_PlanningPosition (Y)
      and Get_PlanningHeading (X) = Get_PlanningHeading (Y))
       with Global => null;
   
   overriding
   function "=" (X,Y : My_PlanningState) return Boolean with
     Global => null,
     Post   => (if "="'Result then Same_Requests (X, Y));
   
   function Unwrap (This : My_PlanningState) return PlanningState;

   function Wrap (This : PlanningState) return My_PlanningState;
   
private
   pragma SPARK_Mode (Off);
   type My_PlanningState is record
      Content : PlanningState;
   end record;
   
    overriding function "=" (X, Y : My_PlanningState) return Boolean is
     (X.Content = Y.Content);
   
   function Unwrap (This : My_PlanningState) return PlanningState is
     (This.Content);

   function Wrap (This : PlanningState) return My_PlanningState is 
     (Content => This);
   
   function Get_EntityId (This : My_PlanningState) return Int64 is
     (This.Content.GetEntityID);
   
   function Get_PlanningPosition (This : My_PlanningState) return My_Location3D_Any is
     (Wrap (This.Content.GetPlanningPosition));
   
   function Get_PlanningHeading (This : My_PlanningState) return Real32 is
     (This.Content.GetPlanningHeading);

end UxAS.Messages.Lmcptask.PlanningState.SPARK_Boundary;
