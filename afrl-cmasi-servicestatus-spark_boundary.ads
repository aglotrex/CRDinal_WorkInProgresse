with Afrl.Cmasi.Enumerations;  use Afrl.Cmasi.Enumerations;
with Afrl.Cmasi.KeyValuePair;  use Afrl.Cmasi.KeyValuePair;
with Afrl.Cmasi.ServiceStatus; use Afrl.Cmasi.ServiceStatus;

with Ada.Containers.Formal_Vectors;

package Afrl.Cmasi.ServiceStatus.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);


   type My_ServiceStatus is private with
     Default_Initial_Condition => True;
   
   
   package Vect_KeyValuePair_P is new Ada.Containers.Formal_Vectors
     (Index_Type   => Natural,
      Element_Type => Afrl.Cmasi.KeyValuePair.KeyValuePair);
   
   use Vect_KeyValuePair_P;
   Vect_KeyValuePair_Commun_Max_Capacity : constant := 200; -- arbitrary
   
   subtype Vect_KeyValuePair is Vect_KeyValuePair_P.Vector
     (Vect_KeyValuePair_Commun_Max_Capacity);
   
  
   function Get_StatusType
     (This : My_ServiceStatus) return ServiceStatusTypeEnum with
     Global => null;
   

   function Get_KeyPairs
     (This : My_ServiceStatus) return Vect_KeyValuePair with
     Global => null;
   

   function Same_Requests (X, Y : My_ServiceStatus) return Boolean is
     (Get_StatusType (X) = Get_StatusType (Y)
      and (First_Index( Get_KeyPairs (X)) = First_Index (Get_KeyPairs (Y))
           and then Last_Index( Get_KeyPairs (X)) = Last_Index (Get_KeyPairs (Y))
           and then (for all I in First_Index( Get_KeyPairs (X)) .. Last_Index( Get_KeyPairs (X))
                     => Element ( Get_KeyPairs (X), I) = Element ( Get_KeyPairs (Y) , I))));
    pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
       
   
     
   procedure Set_StatusType
     (This : in out My_ServiceStatus ;
      StatusType  : ServiceStatusTypeEnum ) with 
     Global => null,
     Post => Get_StatusType (This) = StatusType
     and (First_Index( Get_KeyPairs (This)) = First_Index (Get_KeyPairs (This'Old))
          and then Last_Index( Get_KeyPairs (This)) = Last_Index (Get_KeyPairs (This'Old))
          and then (for all I in First_Index( Get_KeyPairs (This'Old)) .. Last_Index ( Get_KeyPairs (This'Old))
                    => Element ( Get_KeyPairs (This), I) = Element ( Get_KeyPairs (This'Old) , I)));
   
   
   
   procedure Add_KeyPair
     (This : in out My_ServiceStatus ;
      KeyPair_Key  : Unbounded_String;
      KeyPair_Value : Unbounded_String) with 
     Global => null,
     Post => Last_Element ( Get_KeyPairs (This)).GetKey = KeyPair_Key
     and Last_Element ( Get_KeyPairs (This)).GetValue = KeyPair_Value
     and (First_Index( Get_KeyPairs (This)) = First_Index (Get_KeyPairs (This'Old))
          and then Last_Index( Get_KeyPairs (This)) = Last_Index (Get_KeyPairs (This'Old)) + 1
          and then (for all I in First_Index( Get_KeyPairs (This'Old)) .. Last_Index ( Get_KeyPairs (This'Old))
                    => Element ( Get_KeyPairs (This), I) = Element ( Get_KeyPairs (This'Old) , I)))
     and Get_StatusType (This) = Get_StatusType (This'Old);
         
   procedure Add_KeyPair
     (This : in out My_ServiceStatus ;
      KeyPair_Key  : Unbounded_String) with 
     Global => null,
     Post => Last_Element ( Get_KeyPairs (This)).GetKey = KeyPair_Key
     and (First_Index( Get_KeyPairs (This)) = First_Index (Get_KeyPairs (This'Old))
          and then Last_Index( Get_KeyPairs (This)) = Last_Index (Get_KeyPairs (This'Old)) + 1
          and then (for all I in First_Index( Get_KeyPairs (This'Old)) .. Last_Index ( Get_KeyPairs (This'Old))
                    => Element ( Get_KeyPairs (This), I) = Element ( Get_KeyPairs (This'Old) , I)))
     and Get_StatusType (This) = Get_StatusType (This'Old);
   

   overriding
   function "=" (X, Y : My_ServiceStatus) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
   
   function Unwrap (This : My_ServiceStatus) return ServiceStatus with 
     Global => null,
     Inline,
     SPARK_Mode => Off;

   function Wrap (This : ServiceStatus) return My_ServiceStatus with 
     Global => null,
     Inline,
     SPARK_Mode => Off;
   
private
   
   pragma SPARK_Mode(Off);
   
   type My_ServiceStatus is record
      Content : ServiceStatus;
   end record;
   
   function Get_StatusType
     (This : My_ServiceStatus) return ServiceStatusTypeEnum is 
     (This.Content.GetStatusType );
   
   
   overriding 
   function "=" (X, Y : My_ServiceStatus) return Boolean is
     (X.Content = Y.Content); 
   
   function Unwrap (This : My_ServiceStatus) return ServiceStatus is 
     (This.Content);

   function Wrap (This : ServiceStatus ) return My_ServiceStatus is
     (Content => This);
   

end Afrl.Cmasi.ServiceStatus.SPARK_Boundary;
