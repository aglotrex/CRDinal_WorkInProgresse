with UxAS.Messages.Lmcptask.TaskOption.Spark_Boundary; use UxAS.Messages.Lmcptask.TaskOption.Spark_Boundary;
with Ada.Containers.Formal_Vectors;

package UxAS.Messages.Lmcptask.TaskPlanOptions.Spark_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   type My_TaskPlanOptions is private;
   
   
   package Vect_My_TaskOptions is new Ada.Containers.Formal_Vectors
     (Index_Type   => Natural,
      Element_Type => My_TaskOption);
   use Vect_My_TaskOptions;
   Vect_My_TaskOptions_Commun_Max_Capacity : constant := 200; -- arbitrary

   subtype Vect_My_TaskOption is Vect_My_TaskOptions.Vector
     (Vect_My_TaskOptions_Commun_Max_Capacity);
   
   function Get_TaskID
     (This : My_TaskPlanOptions) return Int64
     with Global => null;
   
   function Get_Options
     (This : My_TaskPlanOptions) return Vect_My_TaskOption
     with Global => null;
  
   function Same_Requests (X, Y : My_TaskPlanOptions) return Boolean is
     (First_Index(Get_Options (X)) = First_Index(Get_Options (Y) )
      and then Last_Index(Get_Options (X)) = Last_Index(Get_Options (Y) )
      and then (for all I in First_Index(Get_Options (X)) ..  Last_Index(Get_Options (Y) )
                => (Element(Get_Options (X), I) = Element(Get_Options (Y), I) ))
      and then Get_TaskID (X) = Get_TaskID (Y));
   
   pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
   
   overriding function "=" (X, Y : My_TaskPlanOptions) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
   
   function Unwrap (This : My_TaskPlanOptions) return TaskPlanOptions;

   function Wrap (This : TaskPlanOptions) return My_TaskPlanOptions;
   
private
   pragma SPARK_Mode (Off);
   type My_TaskPlanOptions is record 
      Content : TaskPlanOptions;
   end record;
   
   overriding function "=" (X, Y : My_TaskPlanOptions) return Boolean is
     (X.Content = Y.Content);
   
   function Get_TaskID (This : My_TaskPlanOptions) return Int64 is
     (This.Content.GetTaskID);
     
   function Unwrap (This : My_TaskPlanOptions) return TaskPlanOptions is
     (This.Content);
     

   function Wrap (This : TaskPlanOptions) return My_TaskPlanOptions is 
     (Content => This);
   
end UxAS.Messages.Lmcptask.TaskPlanOptions.Spark_Boundary;
