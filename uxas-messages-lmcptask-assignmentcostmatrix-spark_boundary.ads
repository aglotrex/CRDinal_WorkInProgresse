with Common_Formal_Containers; use  Common_Formal_Containers;
with Ada.Containers.Formal_Vectors;
with UxAS.Messages.Lmcptask.AssignmentCostMatrix; use UxAS.Messages.Lmcptask.AssignmentCostMatrix;
with Uxas.Messages.Lmcptask.TaskOptionCost.SPARK_Boundary; use Uxas.Messages.Lmcptask.TaskOptionCost.SPARK_Boundary;
with Uxas.Messages.Lmcptask.TaskOptionCost; use Uxas.Messages.Lmcptask.TaskOptionCost;


package UxAS.Messages.Lmcptask.AssignmentCostMatrix.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   type My_AssignmentCostMatrix is private;
   
   
   
   package Vect_My_TaskOptionCost_V is new Ada.Containers.Formal_Vectors
     (Index_Type   => Natural,
      Element_Type => My_TaskOptionCost);
   use Vect_My_TaskOptionCost_V;

   Vect_My_TaskOptionCost_Commun_Max_Capacity : constant := 200; -- arbitrary

   subtype Vect_My_TaskOptionCost is Vect_My_TaskOptionCost_V.Vector
     (Vect_My_TaskOptionCost_Commun_Max_Capacity);
   
   function Get_CostMatrix 
     (This : My_AssignmentCostMatrix) return Vect_My_TaskOptionCost;
   
   procedure Add_TaskOptionCost_To_CostMatrix
     (This : in out My_AssignmentCostMatrix;
      TaskOptionCost : My_TaskOptionCost)
     with Global => null,
     Post => Last_Element(Get_CostMatrix(This)) = TaskOptionCost
     and (First_Index(Get_CostMatrix (This)) = First_Index(Get_CostMatrix (This'Old) )+ 1
          and then Last_Index(Get_CostMatrix (This)) = Last_Index(Get_CostMatrix (This'Old) )
          and then (for all I in First_Index(Get_CostMatrix (This'Old)) ..  Last_Index(Get_CostMatrix (This'Old) )
                    => (Element(Get_CostMatrix (This), I) = Element(Get_CostMatrix (This'Old), I) )));
     
   function Same_Requests (X, Y : My_AssignmentCostMatrix) return Boolean is
     (First_Index(Get_CostMatrix (X)) = First_Index(Get_CostMatrix (Y) )
      and then Last_Index(Get_CostMatrix (X)) = Last_Index(Get_CostMatrix (Y) )
      and then (for all I in First_Index(Get_CostMatrix (X)) ..  Last_Index(Get_CostMatrix (Y) )
                => (Element(Get_CostMatrix (X), I) = Element(Get_CostMatrix (Y), I) )));
   pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
   
   overriding function "=" (X, Y : My_AssignmentCostMatrix) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
   
   function Unwrap (This : My_AssignmentCostMatrix) return AssignmentCostMatrix;

   function Wrap (This : AssignmentCostMatrix) return My_AssignmentCostMatrix;
     
private
   pragma SPARK_Mode (Off);
   
   type My_AssignmentCostMatrix is record
      Content : AssignmentCostMatrix;
   end record;
      
   function "=" (X, Y : My_AssignmentCostMatrix) return Boolean is
     (X.Content = Y.Content);
   
   function Unwrap (This : My_AssignmentCostMatrix) return AssignmentCostMatrix is
     (This.Content);

   function Wrap (This : AssignmentCostMatrix) return My_AssignmentCostMatrix is
     (Content => This);
   
   

end UxAS.Messages.Lmcptask.ASsignmentCostMatrix.SPARK_Boundary;
