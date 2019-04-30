with UxAS.Messages.Route.ROuteConstraints.Spark_Boundary; use UxAS.Messages.Route.ROuteConstraints.Spark_Boundary;
with Ada.Containers.Formal_Vectors;

package UxAS.Messages.Route.ROuteConstraints.Spark_Boundary.Vects with SPARK_Mode is

   package Vect_My_RouteConstraints_P is new Ada.Containers.Formal_Vectors
     (Index_Type   => Natural,
      Element_Type => My_RouteConstraints);
   use Vect_My_RouteConstraints_P;

   Vect_My_RouteConstraints_Commun_Max_Capacity : constant := 200; -- arbitrary

   subtype Vect_My_RouteConstraints is Vect_My_RouteConstraints_P.Vector
     (Vect_My_RouteConstraints_Commun_Max_Capacity);

end UxAS.Messages.Route.ROuteConstraints.Spark_Boundary.Vects;
