module.exports = {
    agregar: (req,res)=> {
        var Nombre = req.body.nombre;
        var TipoDocuIdentidad = req.body.TipoDocuIdentidad;
        var ValorDocuIdentidad = req.body.ValorDocuIdentidad;
        var IdDepartamento = req.body.IdDepartamento;
        var IdPuesto = req.body.IdPuesto;
        var output = 0;
        let dbrequest = new sql.Request();
        let dbquery = 'EXEC SP_AgregarArticulo @Codigo, @Nombre, @TipoDocuIdentidad, @ValorDocuIdentidad, @idDepartamento, @idPuesto, @output out';
        if (Nombre && Precio) {
            dbrequest.input('Codigo',sql.VarChar,Codigo);
            dbrequest.input('Nombre',sql.VarChar,Nombre);
            dbrequest.input('TipoDocuIdentidad',sql.int,TipoDocuIdentidad);
            dbrequest.input('ValorDocuIdentidad',sql.int,ValorDocuIdentidad);
            dbrequest.input('idDepartamento',sql.int,IdDepartamento);
            dbrequest.input('idPuesto',sql.int,idPuesto);
            dbrequest.output('output', sql.Int, output);
            dbrequest.query(dbquery, function(err, results, fields) {
                if (results.output.output == 1|results.output.output == 2){
                    if(results.output.output==1){
                        res.send('El puesto del empleado no existe');
                        // revisar
                    }
                    else{
                        res.send('Un empleado con el mismo nombre o el mismo id existe');
                    }
                }        
                else {
                    res.redirect('/main');
                    
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
        let dbquery = 'EXEC SP_BorrarArticulo @Nombre, @output out';
        if (Nombre) {
            dbrequest.input('Nombre',sql.VarChar,Nombre);
            dbrequest.output('output', sql.Int, output);
            dbrequest.query(dbquery, function(err, results, fields) {
                if (results.output.output == 1){
                    res.send('El empleado no existe');
                }        
                else {
                    res.redirect('/main');
                    
                }           
                res.end();
            });
        } else {
            res.send('Porfavor introduzca datos');
            res.end();
        }
    },
        modificar: (req,res)=> {
    }
}