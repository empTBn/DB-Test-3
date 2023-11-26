module.exports = {
    getMainPage: (req, res)=>{
        res.render('main.ejs');


    },
    getAdminMainPage: (req, res)=>{
    var output = 0;
        let dbrequest = new sql.Request();
        let dbquery = "EXEC dbo.sp_MostrarEmpleado @output out";
        dbrequest.output('output',sql.Int, output);//@output
        dbrequest.query(dbquery,function(err,rows,fields){
            if (err) console.log(err)
            else{
                res.render('Main2.ejs', {"Empleado": rows});
            }
        });
    },
    getLogoutPage: (req, res)=>{
        var output = 0;
        let dbrequest = new sql.Request();
        let dbquery = "EXEC dbo.sp_Logout";
        dbrequest.query(dbquery,function(err,rows,fields){
            if (err) console.log(err)
            else{
                res.render('login.ejs');
            }
        });

    },
    getNombre: (req, res)=>{
        var output = 0;
        var Nombre = req.body.inNombreFiltro;
        let dbrequest = new sql.Request();
        let dbquery = "EXEC dbo.sp_FiltrarNombre @Nombre, @output out";
        dbrequest.output('Nombre',sql.VarChar, Nombre);
        dbrequest.output('output',sql.Int, output);//@output
        dbrequest.query(dbquery,function(err,rows,fields){
            if (err) console.log(err)
            else{
                //res.render('main.ejs', {"Articulos": rows});
            }
        });

    },
    getLoginPage: (req, res)=>{
        res.render('login.ejs');
    },
    auth: (req, res)=>{
        var username = req.body.username;//Tomamos la info de la base de datos desde login
        var password = req.body.password;
        console.log(username);
        var output = 0;
        let dbrequest = new sql.Request();
        let dbquery = 'EXEC sp_Login @Usuario, @Password, @output out';//Esto va a estar basicamente en un querry de SQL
        if (username && password) {
            //Dentro de la base de datos
            dbrequest.input('Usuario',sql.VarChar,username);//@Usuario
            dbrequest.input('Password',sql.VarChar,password);//@Password
            dbrequest.output('output', sql.Int, output);//@Output
            dbrequest.query(dbquery, function(error, results, fields) {
                //Ejecucion del querry
                if (results.output.output == 1) {
                    req.session.loggedin = true;
                    req.session.username = username;
                    res.redirect('/main');
                } else {
                    if (results.output.output == 2  ) {
                    req.session.loggedin = true;
                    req.session.username = username;
                    res.redirect('/main2');
                }
                }			
                res.end();
            });
        } else {
            res.send('Please enter Username and Password!');
            res.end();
        }
        },
    
    getAgregarEmpleado: (req, res)=>{
        var output = 0;
        let dbrequest = new sql.Request();
        let dbquery = "EXEC dbo.sp_FiltrarEmpleado @output out";
        dbrequest.output('output',sql.Int, output);//@output
        dbrequest.query(dbquery,function(err,rows,fields){
            if (err) console.log(err)
            else{
                res.render('AgregarEmpleado.ejs', {"ValorDocuIdentidad": rows});
            }
        });

    },
        getBorrarEmpleado: (req, res)=>{
        var output = 0;
        let dbrequest = new sql.Request();
        let dbquery = "EXEC dbo.SP_MostrarEmpleado @output out";
        dbrequest.output('output',sql.Int, output);//@output
        dbrequest.query(dbquery,function(err,rows,fields){
            if (err) console.log(err)
            else{
                res.render('BorrarEmpleado.ejs', {"Empleados": rows});
            }
        });

    },
        EmpleadoPorSemana: (req, res)=>{
        var Nombre = req.body.username;
        var output = 0;
        console.log(Nombre);
        let dbrequest = new sql.Request();
        let dbquery = "EXEC dbo.sp_MostrarEmpleadoSemanal @ValorDocId, @output out";
        dbrequest.input('ValorDocId',sql.Int, Nombre);//@ValorDocId
        dbrequest.output('output',sql.Int, output);//@output
        dbrequest.query(dbquery,function(err,rows,fields){
            if (err) console.log(err)
            else{
                res.render('EmpleadoSemanal.ejs', {"SemanasE": rows});
            }
        });

    },
    EmpleadoPorMes: (req, res)=>{
        var Nombre = req.body.username;
        var output = 0;
        console.log(Nombre);
        let dbrequest = new sql.Request();
        let dbquery = "EXEC dbo.sp_MostrarEmpleadoMes @ValorDocId, @output out";
        dbrequest.input('ValorDocId',sql.Int, Nombre);//@ValorDocId
        dbrequest.output('output',sql.Int, output);//@output
        dbrequest.query(dbquery,function(err,rows,fields){
            if (err) console.log(err)
            else{
                res.render('EmpleadoMes.ejs', {"SemanasE": rows});
            }
        });

    }
    /*
        getEditarEmpleado: (req, res)=>{
        var output = 0;
        let dbrequest = new sql.Request();
        let dbquery = "EXEC dbo.sp_EditarEmpleado @output out";
        dbrequest.output('output',sql.Int, output);//@output
        dbrequest.query(dbquery,function(err,rows,fields){
            if (err) console.log(err)
            else{
                res.render('EditarEmpleado.ejs', {"Empleados": rows});
            }
        });
 // falta SP para editar empleado
    }*/
    
    
}