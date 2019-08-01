with Common_Formal_Containers; use Common_Formal_Containers;
with Afrl.Cmasi.AutomationRequest.SPARK_Boundary; use Afrl.Cmasi.AutomationRequest.SPARK_Boundary;
with Afrl.Impact.ImpactAutomationRequest; use Afrl.Impact.ImpactAutomationRequest;
with Afrl.Impact.ImpactAutomationRequest.SPARK_Boundary; use Afrl.Impact.ImpactAutomationRequest.SPARK_Boundary;
with Avtas.Lmcp.Object.SPARK_Boundary; use Avtas.Lmcp.Object.SPARK_Boundary;
with Uxas.Messages.Lmcptask.TaskAutomationRequest; use Uxas.Messages.Lmcptask.TaskAutomationRequest;
with Uxas.Messages.Lmcptask.TaskAutomationRequest.SPARK_Boundary; use Uxas.Messages.Lmcptask.TaskAutomationRequest.SPARK_Boundary;
with Uxas.Messages.Lmcptask.PlanningState.SPARK_Boundary; use Uxas.Messages.Lmcptask.PlanningState.SPARK_Boundary;
with Ada.Containers.Formal_Vectors;
package UxAS.Messages.LmcpTask.UniqueAutomationRequest.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   --  This package introduces a wrapper around UniqueAutomationRequest.
   --  UniqueAutomationRequest is a private type, so it can be used in SPARK.
   --  This wrapper is only used to introduce contracts on the type and
   --  its accessors.

   use all type Int64_Vect;

   type My_UniqueAutomationRequest is private with
     Default_Initial_Condition =>
       Int64_Vects.Is_Empty (Get_PlanningStates_Ids (My_UniqueAutomationRequest));

   package Vect_My_PlanningState_P is new Ada.Containers.Formal_Vectors
     (Index_Type   => Natural,
      Element_Type => My_PlanningState,
      "="          => UxAS.Messages.Lmcptask.PlanningState.SPARK_Boundary."=");
   use Vect_My_PlanningState_P;

   Vect_My_PlanningState_Commun_Max_Capacity : constant := 200; -- arbitrary

   subtype Vect_My_PlanningState is Vect_My_PlanningState_P.Vector
     (Vect_My_PlanningState_Commun_Max_Capacity);

   function Get_EntityList_From_OriginalRequest
     (Request : My_UniqueAutomationRequest) return Int64_Vect
     with Global => null;

   function Get_OperatingRegion_From_OriginalRequest
     (Request : My_UniqueAutomationRequest) return Int64
     with Global => null;

   function Get_PlanningStates_Ids
     (Request : My_UniqueAutomationRequest) return Int64_Vect
     with Global => null;

   function Get_PlanningStates
     (Request : My_UniqueAutomationRequest) return Vect_My_PlanningState
     with Global => null;

   function GetRequestID
     (This : My_UniqueAutomationRequest) return Int64
     with Global => null;

   function Get_TaskList_From_OriginalRequest
     (Request : My_UniqueAutomationRequest) return Int64_Vect
     with Global => null;

   function Get_TaskRelationship_From_OriginalRequest
     (Request : My_UniqueAutomationRequest) return Unbounded_String;

   function Same_Requests (X, Y : My_UniqueAutomationRequest) return Boolean is
     (Get_PlanningStates_Ids (X) = Get_PlanningStates_Ids (Y)
      and Get_EntityList_From_OriginalRequest (X) =
          Get_EntityList_From_OriginalRequest (Y)
      and Get_OperatingRegion_From_OriginalRequest (X) =
          Get_OperatingRegion_From_OriginalRequest (Y)
      and Get_TaskList_From_OriginalRequest (X) =
          Get_TaskList_From_OriginalRequest (Y));
   pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);

   overriding function "=" (X, Y : My_UniqueAutomationRequest) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));

   procedure Copy_PlanningState_From_TaskAutomationRequest
     (Target : in out My_UniqueAutomationRequest;
      Source : Uxas.Messages.Lmcptask.TaskAutomationRequest.TaskAutomationRequest)
     with Global => null,
     Post => Get_PlanningStates_Ids (Target) =
     Get_PlanningStates_Ids (Source)
     and Get_EntityList_From_OriginalRequest (Target) =
     Get_EntityList_From_OriginalRequest (Target)'Old
     and Get_OperatingRegion_From_OriginalRequest (Target) =
     Get_OperatingRegion_From_OriginalRequest (Target)'Old
     and Get_TaskList_From_OriginalRequest (Target) =
     Get_TaskList_From_OriginalRequest (Target)'Old;

   procedure Copy_OriginalRequest_From_ImpactAutomationRequest
     (Target : in out My_UniqueAutomationRequest;
      Source : ImpactAutomationRequest)
     with Global => null,
     Post => Get_EntityList_From_OriginalRequest (Target) =
     Get_EntityList_From_TrialRequest (Source)
     and Get_OperatingRegion_From_OriginalRequest (Target) =
     Get_OperatingRegion_From_TrialRequest (Source)
     and Get_TaskList_From_OriginalRequest (Target) =
     Get_TaskList_From_TrialRequest (Source)
     and Get_PlanningStates_Ids (Target) =
     Get_PlanningStates_Ids (Target)'Old;

   procedure Copy_OriginalRequest_From_AutomationRequest
     (Target : in out My_UniqueAutomationRequest;
      Source : My_Object_Any)
     with Global => null,
     Pre => Deref (Source) in AutomationRequest,
     Post => Get_EntityList_From_OriginalRequest (Target) =
     Get_EntityList (AutomationRequest (Deref (Source)))
     and Get_OperatingRegion_From_OriginalRequest (Target) =
     Get_OperatingRegion (AutomationRequest (Deref (Source)))
     and Get_TaskList_From_OriginalRequest (Target) =
     Get_TaskList (AutomationRequest (Deref (Source)))
     and Get_PlanningStates_Ids (Target) =
     Get_PlanningStates_Ids (Target)'Old;

   procedure Copy_OriginalRequest_From_TaskAutomationRequest
     (Target : in out My_UniqueAutomationRequest;
      Source : Uxas.Messages.Lmcptask.TaskAutomationRequest.TaskAutomationRequest)
     with Global => null,
     Post => Get_EntityList_From_OriginalRequest (Target) =
     Get_EntityList_From_OriginalRequest (Source)
     and Get_OperatingRegion_From_OriginalRequest (Target) =
     Get_OperatingRegion_From_OriginalRequest (Source)
     and Get_TaskList_From_OriginalRequest (Target) =
     Get_TaskList_From_OriginalRequest (Source)
     and Get_PlanningStates_Ids (Target) =
     Get_PlanningStates_Ids (Target)'Old;

   procedure SetRequestID
     (This : in out My_UniqueAutomationRequest; RequestID : in Int64)
     with Global => null,
     Post => GetRequestID (This) = RequestID
     and Get_EntityList_From_OriginalRequest (This) =
     Get_EntityList_From_OriginalRequest (This)'Old
     and Get_PlanningStates_Ids (This) =
     Get_PlanningStates_Ids (This)'Old
     and Get_OperatingRegion_From_OriginalRequest (This) =
     Get_OperatingRegion_From_OriginalRequest (This)'Old
     and Get_TaskList_From_OriginalRequest (This) =
     Get_TaskList_From_OriginalRequest (This)'Old;

   procedure SetSandBoxRequest
     (This           : in out My_UniqueAutomationRequest;
      SandBoxRequest : Boolean)
     with Global => null,
     Post => Get_EntityList_From_OriginalRequest (This) =
     Get_EntityList_From_OriginalRequest (This)'Old
     and Get_PlanningStates_Ids (This) =
     Get_PlanningStates_Ids (This)'Old
     and Get_OperatingRegion_From_OriginalRequest (This) =
     Get_OperatingRegion_From_OriginalRequest (This)'Old
     and Get_TaskList_From_OriginalRequest (This) =
     Get_TaskList_From_OriginalRequest (This)'Old;
   --  Simple renaming to add a contract

   function Unwrap (This : My_UniqueAutomationRequest) return UniqueAutomationRequest with
     Global => null,
     Inline,
     SPARK_Mode => Off;

   function Wrap (This : UniqueAutomationRequest) return My_UniqueAutomationRequest with
     Global => null,
     Inline,
     SPARK_Mode => Off;

private
   pragma SPARK_Mode (Off);
   type My_UniqueAutomationRequest is record
      Content : UniqueAutomationRequest;
   end record;

   overriding function "=" (X, Y : My_UniqueAutomationRequest) return Boolean is
     (X.Content = Y.Content);

   function GetRequestID (This : My_UniqueAutomationRequest) return Int64 is
     (This.Content.GetRequestID);

   function Get_TaskRelationship_From_OriginalRequest
     (Request : My_UniqueAutomationRequest) return Unbounded_String is
     (Request.Content.GetOriginalRequest.GetTaskRelationships);

   function Unwrap (This : My_UniqueAutomationRequest) return UniqueAutomationRequest is
     (This.Content);

   function Wrap (This : UniqueAutomationRequest) return My_UniqueAutomationRequest is
     (Content => This);
end UxAS.Messages.LmcpTask.UniqueAutomationRequest.SPARK_Boundary;
