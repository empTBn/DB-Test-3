    module.exports = {
        agregar: (req,res)=> {
            var Nombre = req.body.username;
            var TipoDocuIdentidad = req.body.TipoDocuIdentidad;
            var ValorDocuIdentidad = req.body.ValorDocuIdentidad;
            var Departamento = req.body.Departamento;
            var Puesto = req.body.Puesto;
            var Usuario = req.body.usuario;
            var Password = req.body.password;
            var output = 0;
            let dbrequest = new sql.Request();
            let dbquery = 'EXEC sp_AgregarEmpleadoIndividual @ValorDocId, @TipoValorDocId, @Nombre, @Username, @Password, @Departamento,@Puesto, @output out';
            if (Nombre && TipoDocuIdentidad) {
                dbrequest.input('ValorDocId',sql.Int,ValorDocuIdentidad);
                dbrequest.input('TipoValorDocId',sql.VarChar,TipoDocuIdentidad);
                dbrequest.input('Nombre',sql.VarChar,Nombre);
                dbrequest.input('Username',sql.VarChar,Usuario);
                dbrequest.input('Password',sql.VarChar,Password);
                dbrequest.input('Departamento',sql.VarChar,Departamento);
                dbrequest.input('Puesto',sql.VarChar,Puesto);
                dbrequest.output('output', sql.Int, output);
                dbrequest.query(dbquery, function(err, results, fields) {
                    if (results.output.output == 1|results.output.output == 2){
                        if(results.output.output==1){
                            res.send('El puesto o el departamento del empleado no existe');
                            // revisar
                        }
                        else{
                            res.send('Un empleado con el mismo nombre, Valor de documento de identidad o Usuario ya existe');
                        }
                    }        
                    else {
                        res.redirect('/main2');
                        
                    }			
                    res.end();
                });
            } else {
                res.send('Porfavor introduzca datos');
                res.end();
            }
        },

        borrar: (req,res)=> {
            var Nombre = req.body.username;
            var output = 0;
            let dbrequest = new sql.Request();
            let dbquery = 'EXEC SP_BorrarEmpleadoIndividual @Nombre, @output out';
            if (Nombre) {
                dbrequest.input('Nombre',sql.VarChar,Nombre);
                dbrequest.output('output', sql.Int, output);
                dbrequest.query(dbquery, function(err, results, fields) {
                    if (results.output.output == 1){
                        res.send('El empleado no existe');
                    }        
                    else {
                        res.redirect('/main2');
                        
                    }           
                    res.end();
                });
            } else {
                res.send('Porfavor introduzca datos');
                res.end();
            }
        },
        modificar: (req,res)=> {
            var NombreE = req.body.usernameE;
            var NombreS = req.body.usernameS;
            var TipoDocuIdentidad = req.body.TipoDocuIdentidad;
            var ValorDocuIdentidad = req.body.ValorDocuIdentidad;
            var Departamento = req.body.Departamento;
            var Puesto = req.body.Puesto;
            var Usuario = req.body.usuario;
            var Password = req.body.password;
            var output = 0;
            let dbrequest = new sql.Request();
            let dbquery = 'EXEC SP_ModificarEmpleado @NombreE, @ValorDocId, @TipoValorDocId, @NombreS, @Username, @Password, @Departamento,@Puesto, @output out';
            if (NombreE && TipoDocuIdentidad) {
                dbrequest.input('NombreE',sql.VarChar,NombreE);
                dbrequest.input('ValorDocId',sql.Int,ValorDocuIdentidad);
                dbrequest.input('TipoValorDocId',sql.VarChar,TipoDocuIdentidad);
                dbrequest.input('NombreS',sql.VarChar,NombreS);
                dbrequest.input('Username',sql.VarChar,Usuario);
                dbrequest.input('Password',sql.VarChar,Password);
                dbrequest.input('Departamento',sql.VarChar,Departamento);
                dbrequest.input('Puesto',sql.VarChar,Puesto);
                dbrequest.output('output', sql.Int, output);
                dbrequest.query(dbquery, function(err, results, fields) {
                if (results.output.output == 1||results.output.output == 2||results.output.output == 3||results.output.output == 4){
                        if(results.output.output == 1){
                            res.send('El departamento, el Puesto o el Tipo de documento de identidad no existen');
                        }
                        if(results.output.output == 2){
                            res.send('El nombre del empleado que se busca modificar no existe');
                        }
                        if(results.output.output == 3){
                            res.send('La nombre del Empleado o el Usuario a modificar ya existe');
                        }
                        if(results.output.output == 4){
                            res.send('El Valor de documento de identificacion a modificar ya existe');
                        }
                    }        
                    else {
                        res.redirect('/main2');
                        
                    }           
                    res.end();
                });
            } else {
                res.send('Porfavor introduzca datos');
                res.end();
            }
        }
    }