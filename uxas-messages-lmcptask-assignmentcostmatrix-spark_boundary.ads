with Ada.Containers.Formal_Vectors;
with UxAS.Messages.Lmcptask.AssignmentCostMatrix; use UxAS.Messages.Lmcptask.AssignmentCostMatrix;
with Uxas.Messages.Lmcptask.TaskOptionCost.SPARK_Boundary; use Uxas.Messages.Lmcptask.TaskOptionCost.SPARK_Boundary;

with Uxas.Messages.Lmcptask.TaskOptionCost;

with Common_Formal_Containers; use Common_Formal_Containers;

package UxAS.Messages.Lmcptask.AssignmentCostMatrix.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   type My_AssignmentCostMatrix is private with
   Default_Initial_Condition => True;
   
   use all type Int64_Vect;

   package Vect_My_TaskOptionCost_V is new Ada.Containers.Formal_Vectors
     (Index_Type   => Natural,
      Element_Type => My_TaskOptionCost,
      "="          => Uxas.Messages.Lmcptask.TaskOptionCost.SPARK_Boundary."=");
   use Vect_My_TaskOptionCost_V;

   Vect_My_TaskOptionCost_Commun_Max_Capacity : constant := 200; -- arbitrary

   subtype Vect_My_TaskOptionCost is Vect_My_TaskOptionCost_V.Vector
     (Vect_My_TaskOptionCost_Commun_Max_Capacity);
   
      
   function Get_CorrespondingAutomationRequestID
     (This : My_AssignmentCostMatrix) return Int64 with
     Global => null;
   
   
   function Get_OperatingRegion
     (This : My_AssignmentCostMatrix) return Int64 with
     Global => null;
     
   function Get_TaskLevelRelationship
     (This : My_AssignmentCostMatrix) return Unbounded_String with
     Global => null;
   
   function Get_TaskList
     (This : My_AssignmentCostMatrix) return Int64_Vect with
     Global => null;
   
   function Get_CostMatrix 
     (This : My_AssignmentCostMatrix) return Vect_My_TaskOptionCost;
   
   procedure Add_TaskOptionCost_To_CostMatrix
     (This : in out My_AssignmentCostMatrix;
      Task_OptionCost : My_TaskOptionCost)
     with --  Global => null,
       Post => Last_Element(Get_CostMatrix(This)) = Task_OptionCost
       and (First_Index(Get_CostMatrix (This)) = First_Index(Get_CostMatrix (This'Old) )+ 1
            and then Last_Index(Get_CostMatrix (This)) = Last_Index(Get_CostMatrix (This'Old) )
            and then (for all I in First_Index(Get_CostMatrix (This'Old)) ..  Last_Index(Get_CostMatrix (This'Old) )
                      => (Element(Get_CostMatrix (This), I) = Element(Get_CostMatrix (This'Old), I) )))
     and Get_CorrespondingAutomationRequestID (This) = Get_CorrespondingAutomationRequestID (This'Old)
     and Get_OperatingRegion (This) = Get_OperatingRegion (This'Old)
     and Get_TaskLevelRelationship (This) = Get_TaskLevelRelationship (This'Old)
     and (First_Index(Get_TaskList (This)) = First_Index(Get_TaskList (This'Old) )
          and then Last_Index(Get_TaskList (This)) = Last_Index(Get_TaskList (This'Old) )
          and then (for all I in First_Index(Get_TaskList (This'Old)) ..  Last_Index(Get_TaskList (This'Old) )
                    => (Element(Get_TaskList (This), I) = Element(Get_TaskList (This'Old), I) )));
     
  
   
   function Same_Requests (X, Y : My_AssignmentCostMatrix) return Boolean is
     (Get_CorrespondingAutomationRequestID (X) = Get_CorrespondingAutomationRequestID (Y)
      and Get_OperatingRegion (X) = Get_OperatingRegion (Y)
      and Get_TaskLevelRelationship (X) = Get_TaskLevelRelationship (Y)
      and (First_Index(Get_TaskList (X)) = First_Index(Get_TaskList (Y) )
           and then Last_Index(Get_TaskList (X)) = Last_Index(Get_TaskList (Y) )
           and then (for all I in First_Index(Get_TaskList (Y)) ..  Last_Index(Get_TaskList (Y) )
                     => (Element(Get_TaskList (X), I) = Element(Get_TaskList (Y), I) )))
      and   (First_Index(Get_CostMatrix (X)) = First_Index(Get_CostMatrix (Y) )
             and then Last_Index(Get_CostMatrix (X)) = Last_Index(Get_CostMatrix (Y) )
             and then (for all I in First_Index(Get_CostMatrix (X)) ..  Last_Index(Get_CostMatrix (Y) )
                       => (Element(Get_CostMatrix (X), I) = Element(Get_CostMatrix (Y), I) ))));
   pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
   
   overriding function "=" (X, Y : My_AssignmentCostMatrix) return Boolean with
   -- Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
   
   procedure Set_CorrespondingAutomationRequestID
     (This : in out My_AssignmentCostMatrix;
      CorrespondingAutomationRequestID : Int64) with
     --  Global => null,
     Post => Get_CorrespondingAutomationRequestID (This) = CorrespondingAutomationRequestID
     and Get_OperatingRegion (This) = Get_OperatingRegion (This'Old)
     and Get_TaskLevelRelationship (This) = Get_TaskLevelRelationship (This'Old)
     and (First_Index(Get_TaskList (This)) = First_Index(Get_TaskList (This'Old) )
          and then Last_Index(Get_TaskList (This)) = Last_Index(Get_TaskList (This'Old) )
          and then (for all I in First_Index(Get_TaskList (This'Old)) ..  Last_Index(Get_TaskList (This'Old) )
                    => (Element(Get_TaskList (This), I) = Element(Get_TaskList (This'Old), I) )))
     and (First_Index(Get_CostMatrix (This)) = First_Index(Get_CostMatrix (This'Old) )
          and then Last_Index(Get_CostMatrix (This)) = Last_Index(Get_CostMatrix (This'Old) )
          and then (for all I in First_Index(Get_CostMatrix (This'Old)) ..  Last_Index(Get_CostMatrix (This'Old) )
                    => (Element(Get_CostMatrix (This), I) = Element(Get_CostMatrix (This'Old), I) )));
   
   procedure Set_OperatingRegion
     (This : in out My_AssignmentCostMatrix;
      OperatingRegion : Int64) with
   --  Global => null,
     Post => Get_OperatingRegion (This) = OperatingRegion
     and Get_CorrespondingAutomationRequestID (This) = Get_CorrespondingAutomationRequestID (This'Old)
     and Get_TaskLevelRelationship (This) = Get_TaskLevelRelationship (This'Old)
     and (First_Index(Get_TaskList (This)) = First_Index(Get_TaskList (This'Old) )
          and then Last_Index(Get_TaskList (This)) = Last_Index(Get_TaskList (This'Old) )
          and then (for all I in First_Index(Get_TaskList (This'Old)) ..  Last_Index(Get_TaskList (This'Old) )
                    => (Element(Get_TaskList (This), I) = Element(Get_TaskList (This'Old), I) )))
     and (First_Index(Get_CostMatrix (This)) = First_Index(Get_CostMatrix (This'Old) )
          and then Last_Index(Get_CostMatrix (This)) = Last_Index(Get_CostMatrix (This'Old) )
          and then (for all I in First_Index(Get_CostMatrix (This'Old)) ..  Last_Index(Get_CostMatrix (This'Old) )
                    => (Element(Get_CostMatrix (This), I) = Element(Get_CostMatrix (This'Old), I) )));
   
      
   procedure Set_TaskLevelRelationship
     (This : in out My_AssignmentCostMatrix;
      TaskLevelRelationship : Unbounded_String) with
   --   Global => null,
     Post =>  Get_TaskLevelRelationship (This) = TaskLevelRelationship
     and Get_CorrespondingAutomationRequestID (This) = Get_CorrespondingAutomationRequestID (This'Old)
     and Get_OperatingRegion (This) = Get_OperatingRegion (This'Old)
     and (First_Index(Get_TaskList (This)) = First_Index(Get_TaskList (This'Old) )
          and then Last_Index(Get_TaskList (This)) = Last_Index(Get_TaskList (This'Old) )
          and then (for all I in First_Index(Get_TaskList (This'Old)) ..  Last_Index(Get_TaskList (This'Old) )
                    => (Element(Get_TaskList (This), I) = Element(Get_TaskList (This'Old), I) )))
     and (First_Index(Get_CostMatrix (This)) = First_Index(Get_CostMatrix (This'Old) )
          and then Last_Index(Get_CostMatrix (This)) = Last_Index(Get_CostMatrix (This'Old) )
          and then (for all I in First_Index(Get_CostMatrix (This'Old)) ..  Last_Index(Get_CostMatrix (This'Old) )
                    => (Element(Get_CostMatrix (This), I) = Element(Get_CostMatrix (This'Old), I) )));
   
      
   procedure Set_TaskList
     (This : in out My_AssignmentCostMatrix;
      TaskList : Int64_Vect) with
   -- GLobal => null,
     Post => (First_Index(Get_TaskList (This)) = First_Index(TaskList)
              and then Last_Index(Get_TaskList (This)) = Last_Index(TaskList)
              and then (for all I in First_Index(TaskList) ..  Last_Index(TaskList )
                => (Element(Get_TaskList (This), I) = Element(TaskList, I) )))
     and Get_CorrespondingAutomationRequestID (This) = Get_CorrespondingAutomationRequestID (This'Old)
     and Get_OperatingRegion (This) = Get_OperatingRegion (This'Old)
     and Get_TaskLevelRelationship (This) = Get_TaskLevelRelationship (This'Old)
     and (First_Index(Get_CostMatrix (This)) = First_Index(Get_CostMatrix (This'Old) )
          and then Last_Index(Get_CostMatrix (This)) = Last_Index(Get_CostMatrix (This'Old) )
          and then (for all I in First_Index(Get_CostMatrix (This'Old)) ..  Last_Index(Get_CostMatrix (This'Old) )
                    => (Element(Get_CostMatrix (This), I) = Element(Get_CostMatrix (This'Old), I) )));
   
   
   
   function Unwrap (This : My_AssignmentCostMatrix) return AssignmentCostMatrix;

   function Wrap (This : AssignmentCostMatrix) return My_AssignmentCostMatrix;
     
private
   pragma SPARK_Mode (Off);
   
   type My_AssignmentCostMatrix is record
      Content : AssignmentCostMatrix;
   end record;
   
   function Get_CorrespondingAutomationRequestID (This : My_AssignmentCostMatrix) return Int64 is 
     (This.Content.GetCorrespondingAutomationRequestID);
   
   function Get_OperatingRegion (This : My_AssignmentCostMatrix) return Int64 is 
     (This.Content.GetOperatingRegion);
   
   function Get_TaskLevelRelationship (This : My_AssignmentCostMatrix) return Unbounded_String is 
     (This.Content.GetTaskLevelRelationship);
      
   overriding 
   function "=" (X, Y : My_AssignmentCostMatrix) return Boolean is
     (X.Content = Y.Content);
   
   function Unwrap (This : My_AssignmentCostMatrix) return AssignmentCostMatrix is
     (This.Content);

   function Wrap (This : AssignmentCostMatrix) return My_AssignmentCostMatrix is
     (Content => This);
   
   

end UxAS.Messages.Lmcptask.ASsignmentCostMatrix.SPARK_Boundary;
