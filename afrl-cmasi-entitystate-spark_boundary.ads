with Common_Formal_Containers; use Common_Formal_Containers;
with Afrl.Cmasi.Location3D.SPARK_Boundary; use Afrl.Cmasi.Location3D.SPARK_Boundary;


package Afrl.Cmasi.EntityState.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   use all type Int64_Vect;
   
   type My_EntityState is private with
   Default_Initial_Condition => True;
   
   function Get_ID
     (This : My_EntityState) return Int64 with 
     Global => null;
   
   function Get_Heading
     (This : My_EntityState) return Real32 with 
     Global => null;
   
   function Get_Location
     (This : My_EntityState) return My_Location3D_Any with 
     Global => null;
   
   function Same_Requests (X, Y : My_EntityState) return Boolean is
     (Get_ID (X) = Get_ID (Y)
      and Get_Heading (X) = Get_Heading (Y)
      and Get_Location (X) = Get_Location (Y));
   pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
   
   
   overriding
   function "=" (X, Y : My_EntityState) return Boolean with
     Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
   
   function Unwrap (This : My_EntityState) return EntityState;

   function Wrap (This : EntityState) return My_EntityState;
   
 

private
   pragma SPARK_Mode(Off);
   
   type My_EntityState is record
      Content : EntityState;
   end record;
   
   function Get_ID (This : My_EntityState) return Int64 is
     (THis.Content.GetID);
   
   function Get_Heading (THis : My_EntityState) return Real32 is 
     (This.Content.GetHeading);
   function Get_Location (This : My_EntityState) return My_Location3D_Any is
     (Wrap(This.Content.GetLocation));
   
   overriding 
   function "=" (X, Y : My_EntityState) return Boolean is
     (X.Content = Y.Content); 
   
   function Unwrap (This : My_EntityState) return EntityState is 
     (This.Content);

   function Wrap (This : EntityState ) return My_EntityState is
     (Content => This);
   
end Afrl.Cmasi.EntityState.SPARK_Boundary;
