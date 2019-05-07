with Common_Formal_Containers; use Common_Formal_Containers;
package afrl.cmasi.EntityState.SPARK_Boundary with SPARK_Mode is
   pragma Annotate (GNATprove, Terminating, SPARK_Boundary);

   use all type Int64_Vect;
   
   type My_EntityState is private;
   
   overriding
   function "=" (X, Y : My_EntityState) return Boolean;
   
private
   pragma SPARK_Mode(Off);
   
   type My_EntityState is record
      Content : EntityState;
   end record;
   
   overriding 
   function "=" (X, Y : My_EntityState) return Boolean is
     (X.Content = Y.Content);
   
   function Wrap (Region : EntityState) return My_EntityState is
     (Content => Region);
   
   function Unwrap ( Region : My_EntityState) return EntityState is
     (Region.Content);
   
end afrl.cmasi.EntityState.SPARK_Boundary;
