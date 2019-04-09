
package body convert with SPARK_Mode is

   procedure modulo(Dividend, Divisor : in  Long_Float ;
                    Quotient, Result  : out Long_Float) is
    
   begin
      if (0.0 <= Dividend and Dividend < Divisor) then
         Quotient := 0.0 ;
      else
         Quotient := Long_Float'Floor(Dividend / Divisor);
      end if;
      result := Dividend - (Divisor * Quotient);
   end modulo;
   
   procedure modulo(Dividend, Divisor : in  Float ;
                    Quotient, Result  : out Float) is
   
   begin
      if (0.0 <= Dividend and Dividend < Divisor) then
         Quotient := 0.0 ;
      else
         Quotient := Float'Floor(Dividend / Divisor);
      end if;
      result := Dividend - (Divisor * Quotient);
   end modulo;
   
   function Compare(Argument1 : Long_Float;
                    Argument2 : Long_Float;
                    rel_Operator : En_Relational_Operators;
                    Epsilon   : Long_Float :=(10.0**(-9)) ) return Boolean
   is
   begin
      
         
      case rel_Operator is 
         -- bReturn = (dArgument1 > dArgument2);
         when  enGreater      =>  return Argument1 > Argument2;
               
            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enGreater) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enGreaterEqual =>  return(Compare(Argument1,Argument2,enGreater)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
            -- bReturn = (dArgument1 < dArgument2);   
         when enLess         => return (Argument1 < Argument2);
               
            -- bReturn = (bCompareDouble(dArgument1, dArgument2, enLess) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enLessEqual    => return (Compare(Argument1,Argument2,enLess)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
            --  bReturn = (std::fabs(dArgument1 - dArgument2) <= dEpsilon);
         when others        => return (abs(Argument1 - Argument2) <= Epsilon);
      end case;
         
   end Compare;
   
   function Compare(Argument1 : Float;
                    Argument2 : Float;
                    rel_Operator : En_Relational_Operators;
                    Epsilon   : Float := (10.0**(-9))) return Boolean
   
   is
   begin
         
      case rel_Operator is 
         -- bReturn = (dArgument1 > dArgument2);
         when  enGreater      =>  return Argument1 > Argument2;
               
            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enGreater) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enGreaterEqual =>  return(Compare(Argument1,Argument2,enGreater)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
            -- bReturn = (dArgument1 < dArgument2);   
         when enLess         => return (Argument1 < Argument2);
               
            -- bReturn = (bCompareDouble(dArgument1, dArgument2, enLess) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enLessEqual    => return (Compare(Argument1,Argument2,enLess)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
            --  bReturn = (std::fabs(dArgument1 - dArgument2) <= dEpsilon);
         when others        => return (abs(Argument1 - Argument2) <= Epsilon);
      end case;
   end Compare;
   
   function Normalize_Angle ( Angle           : Long_Float;
                              Angle_Reference : Long_Float;
                              Full_Turn_Unit  : Long_Float) return Long_Float is
     
      Mod_Angle : Long_Float;
      N         : Long_Float;
   begin 
      pragma Assert (Full_Turn_Unit > 0.0);
      -- double dModAngle = modulo (dAngleRad,/Full_Turn/);
      modulo (Dividend => Angle,
              Divisor  => Full_Turn_Unit,
              Quotient => N,
              Result   => Mod_Angle);
      
      pragma Assert( 0.0 <= Mod_Angle and Mod_Angle < Full_Turn_Unit);
      
      -- assert( dAngleReference <= 0.0 && dAngleReference >= /Full_Turn/ );
      -- if( bCompareDouble(dModAngle, dAngleReference, enLess) )
      -- {
      --    dModAngle += /Full_Turn/;
      -- }
      ---- unreachable code 
      --   0.0 <= Mod_Angle 
      --  Angle_Reference <= 0.0
      --   => NOT  Mod_Angle < Angle-Reference
         
      --  else if( bCompareDouble(dModAngle, (dAngleReference+ /Full_Turn/ ), enGreaterEqual) )   
      if Angle_Reference + Full_Turn_Unit <= Mod_Angle then
         pragma Assert( Angle_Reference + Full_Turn_Unit <= Mod_Angle 
                        and Mod_Angle < Full_Turn_Unit  );
         Mod_Angle := Mod_Angle - Full_Turn_Unit;
         pragma Assert( Angle_Reference <= Mod_Angle 
                        and Mod_Angle < Full_Turn_Unit - Full_Turn_Unit );
      else
         pragma Assert(not ((Angle_Reference + Full_Turn_Unit) <= Mod_Angle));
         pragma Assert( 0.0 <= Mod_Angle 
                        and Mod_Angle < (Angle_Reference + Full_Turn_Unit));
      end if;
      
      pragma Assert( Angle_Reference <= Mod_Angle 
                     and Mod_Angle < (Angle_Reference + Full_Turn_Unit) );
      return Mod_Angle;
   end Normalize_Angle;
      
      
    
   
   -- static void vRound(double& rdNumber,const double dDecimalPlace)
   procedure vRound(Number : in out Long_Float; 
                    Decimel_Place : in Long_Float)is 
   begin
      Number := dRound(Number        => Number,
                       Decimal_Place => Decimel_Place);
   end vRound;
        
                      
      

end convert;
