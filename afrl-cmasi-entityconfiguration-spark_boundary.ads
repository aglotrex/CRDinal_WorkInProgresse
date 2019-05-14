package Afrl.Cmasi.EntityConfiguration.SPARK_Boundary is

   type My_EntityConfiguration is private with 
   Default_Initial_Condition => True;
   
   function Get_ID
     (This : My_EntityConfiguration) return Int64 with
     Global => null;
   
   function Get_NominalSpeed
     (this : My_EntityConfiguration) return Real32 with
    Global => null;
   
    function Same_Requests (X, Y : My_EntityConfiguration) return Boolean is
     (Get_ID (X) = Get_ID (Y)
      and Get_NominalSpeed (X) = Get_NominalSpeed (Y));
   pragma Annotate (GNATprove, Inline_For_Proof, Same_Requests);
   
   overriding
   function "=" (X, Y : My_EntityConfiguration) return Boolean with
    Global => null,
     Post => (if "="'Result then Same_Requests (X, Y));
   
   function Unwrap (This : My_EntityConfiguration) return EntityConfiguration;

   function Wrap (This : EntityConfiguration) return My_EntityConfiguration;
   
private
   type My_EntityConfiguration is record
      Content : EntityConfiguration;
   end record;
 
   function Get_ID (This : My_EntityConfiguration) return Int64 is
     (This.Content.GetID);
   
   function Get_NominalSpeed (This : My_EntityConfiguration) return Real32 is
      (This.Content.GetNominalSpeed);
   
    overriding 
   function "=" (X, Y : My_EntityConfiguration) return Boolean is
     (X.Content = Y.Content); 
   
   function Unwrap (This : My_EntityConfiguration) return EntityConfiguration is 
      (This.Content);

   function Wrap (This : EntityConfiguration) return My_EntityConfiguration is
      (Content => This);

end Afrl.Cmasi.EntityConfiguration.SPARK_Boundary;
