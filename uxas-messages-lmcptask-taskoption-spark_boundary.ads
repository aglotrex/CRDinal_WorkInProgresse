with Afrl.Cmasi.Location3D.Spark_Boundary; use Afrl.Cmasi.Location3D.Spark_Boundary;
with Common_Formal_Containers; use Common_Formal_Containers;



package UxAS.Messages.Lmcptask.TaskOption.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   type My_TaskOption is private;
   
   use all type Int64_Vect;
      
   function Get_TaskID
     (This : My_TaskOption) return Int64
     with Global => null;
   
   function Get_OptionID
     (THis : My_TaskOption) return Int64
     with Global => null;
   
   function Get_StartLocation 
     (This : My_TaskOption) return My_Location3D_Any
     with Global => null;
   
   
   function Get_StartHeading
     (THis : My_TaskOption) return Real32
     with Global => null;
   
   function Get_EndLocation
     (THis : My_TaskOption) return My_Location3D_Any
     with Global => null;
   
   function Get_EndHeading
     (This : My_TaskOption) return Real32
     with Global => null;

   function Get_EligibleEntities
     (This : My_TaskOption) return Int64_Vect
     with Global => null;
   
   function Same_Requests (X, Y : My_TaskOption) return Boolean is
     (Get_TaskID (X) = Get_TaskID (Y)
      and Get_OptionID (X) = Get_OptionID (Y)
      and Get_StartLocation (X) = Get_StartLocation (Y)
      and Get_StartHeading  (X) = Get_StartHeading  (Y)
      and Get_EndLocation   (X) = Get_EndLocation   (Y)
      and Get_EndHeading    (X) = Get_EndHeading    (Y)
      and Get_EligibleEntities (X) = Get_EligibleEntities (Y) );
   pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
   
    overriding function "=" (X, Y : My_TaskOption) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
   
    function Unwrap (this : My_TaskOption) return TaskOption;

   function Wrap (this : TaskOption) return My_TaskOption;
   
private
   pragma SPARK_Mode (Off);
   type My_TaskOption is record 
      Content : TaskOption;
   end record;
   
   overriding function "=" (X, Y : My_TaskOption) return Boolean is
     (X.Content = Y.Content);
   
   
   function Get_TaskID (This : My_TaskOption) return Int64 is
      (This.Content.GetTaskID);
   
   function Get_OptionID (THis : My_TaskOption) return Int64 is
      (This.Content.GetOptionID);
   
   function Get_StartLocation   (This : My_TaskOption) return My_Location3D_Any is
      (Wrap(This.Content.GetStartLocation));
   
   
   function Get_StartHeading (This : My_TaskOption) return Real32 is
      (This.Content.GetStartHeading);
   
   function Get_EndLocation (This : My_TaskOption) return My_Location3D_Any is
      (Wrap(This.Content.GetEndLocation));
   
   function Get_EndHeading (This : My_TaskOption) return Real32 is
      (This.Content.GetEndHeading);

   
    function Unwrap (this : My_TaskOption) return TaskOption is
     (this.Content);

   function Wrap (this : TaskOption) return My_TaskOption is
     (Content => this);
   
   
   

end UxAS.Messages.Lmcptask.TaskOption.SPARK_Boundary;
