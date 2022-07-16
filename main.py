

from flask import Flask,render_template,request,session,redirect,url_for,flash
from flask_sqlalchemy import SQLAlchemy,sqlalchemy
from sqlalchemy import text
from flask_login import UserMixin
from werkzeug.security import generate_password_hash,check_password_hash
from flask_login import login_user,logout_user,login_manager,LoginManager
from flask_login import login_required,current_user
from flask_mail import Mail
import json


with open("config.json",'r') as c:
    params=json.load(c)["params"] 




#database connection
local_server=True
app=Flask(__name__)
app.secret_key="guru"

# this is for getting unique user access
login_manager=LoginManager(app)
login_manager.login_view='login'


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

app.config['SQLALCHEMY_DATABASE_URI']="mysql://root:@localhost:3306/mahadeva"
db=SQLAlchemy(app)


class Test(db.Model):
    id=db.Column(db.Integer,primary_key=True)
    fname=db.Column(db.String(20))
    lname=db.Column(db.String(20))

class User(UserMixin,db.Model):
     id=db.Column(db.Integer,primary_key=True)
     username=db.Column(db.String(30))
     email=db.Column(db.String(30),unique=True)
     password=db.Column(db.String(1000))

class Patients(db.Model):
    pid=db.Column(db.Integer,primary_key=True)
    email=db.Column(db.String(50))
    fname=db.Column(db.String(50))
    gender=db.Column(db.String(50))
    slot=db.Column(db.String(50))
    disease=db.Column(db.String(50))
    time=db.Column(db.String(6),nullable=False)
    date=db.Column(db.String(15),nullable=False)
    dept=db.Column(db.String(50))
    phno=db.Column(db.String(50))
    lname=db.Column(db.String(50)) 

class Doctor(db.Model):
    doctorid=db.Column(db.Integer,primary_key=True)
    email=db.Column(db.String(40),unique=True)
    dname=db.Column(db.String(40))
    dlname=db.Column(db.String(40))
    ddept=db.Column(db.String(40))
    doctor_gender=db.Column(db.String(40))
    dphno=db.Column(db.String(40))

class Triger(db.Model):
    trigerID=db.Column(db.Integer,primary_key=True)
    pid=db.Column(db.String(40))
    email=db.Column(db.String(40))
    fname=db.Column(db.String(40))
    dept=db.Column(db.String(40))
    action=db.Column(db.String(40))
    timestamp=db.Column(db.String(40))    

class Vaccine(db.Model):
    vid=db.Column(db.Integer,primary_key=True)
    email=db.Column(db.String(40))    
    fname=db.Column(db.String(40))
    lname=db.Column(db.String(40))
    gender=db.Column(db.String(40))
    vaccine=db.Column(db.String(40))
    dose=db.Column(db.String(40))
    age=db.Column(db.String(40))
    slot=db.Column(db.String(40))
    time=db.Column(db.String(40))
    date=db.Column(db.String(40))
    phno=db.Column(db.String(40))


#testing the database connection
@app.route("/test")
def test():
    try:
        Test.query.all()
        return "database connected"
    except Exception as e:
        return f'database not connected{e}'  

@app.route("/")
def home():
    return render_template("index.html")   



@app.route("/adminlogin",methods=['POST','GET'])
def adminlogin():
    if request.method=="POST":
        adminemail=request.form.get('adminemail')
        adminpassword=request.form.get('adminpassword')
        if(adminemail==params['adminemail'] and adminpassword==params['adminpassword']):
            session['adminemail']=adminemail
            flash("login success","info")
            return render_template('doctor.html')
        else:
            flash("invalid credential","warning")    
            return render_template('adminlogin.html')     
         
    return render_template('adminlogin.html')





@app.route("/booking")
@login_required
def booking():
    cemail=current_user.email
    query=db.engine.execute(f"SELECT * FROM `Patients` WHERE email='{cemail}'")   
    return render_template("booking.html",query=query) 

@app.route("/vaccinbook")
@login_required
def vaccinebooking():
    cemail=current_user.email
    query=db.engine.execute(f"SELECT * FROM `Vaccine` WHERE email='{cemail}'")   
    return render_template("vaccinationbooked.html",query=query) 


@app.route("/doctordetails")
@login_required
def doctordetails():
#cemail=current_user.email
    
    query=db.engine.execute(sqlalchemy.text("CALL doctorroutine()"))  
    print(query) 
    return render_template("doctordetails.html",query=query) 

@app.route("/doctor",methods=['POST','GET'])

def doctor():
    if('adminemail' in session and session['adminemail']==params['adminemail']):
        if request.method=="POST":
            email=request.form.get('email')
            dname=request.form.get('dname')
            dlname=request.form.get('dlname')
            doctor_gender=request.form.get('doctor_gender')
            ddept=request.form.get('ddept')
            dphno=request.form.get('dphno')
            new_slot=db.engine.execute(f"INSERT INTO `doctor` (`email`,`dname`,`dlname`,`doctor_gender`,`ddept`,`dphno`) VALUES ('{email}','{dname}','{dlname}','{doctor_gender}','{ddept}','{dphno}')") 
            flash("data added successfully","info")   
            return render_template("doctor.html") 
    else:
        flash("not a admin","warning")
        return render_template("index.html")


    return render_template("doctor.html") 

@app.route("/patientsbooking",methods=['POST','GET'])
@login_required
def bookappointment():
    doct=db.engine.execute("SELECT * FROM `doctor`")
    
    if request.method=="POST":
        email=request.form.get('email')
        fname=request.form.get('fname')
        lname=request.form.get('lname')
        gender=request.form.get('gender')
        slot=request.form.get('slot')
        disease=request.form.get('disease')
        time=request.form.get('time')
        date=request.form.get('date')
        dept=request.form.get('dept')
        phno=request.form.get('number')
        new_slot=db.engine.execute(f"INSERT INTO `patients` (`email`,`fname`,`lname`,`gender`,`slot`,`disease`,`time`,`date`,`dept`,`phno`) VALUES ('{email}','{fname}','{lname}','{gender}','{slot}','{disease}','{time}','{date}','{dept}','{phno}')")
         
# mail starts from here

        # mail.send_message(subject, sender=params['gmail-user'], recipients=[email],body=f"YOUR bOOKING IS CONFIRMED THANKS FOR CHOOSING US \nYour Entered Details are :\nName: {name}\nSlot: {slot}")



        flash("Booking Confirmed","info")
    return render_template("patientsbooking.html",doct=doct) 

@app.route("/edit/<string:pid>",methods=['POST','GET'])
@login_required
def edit(pid):
    posts=Patients.query.filter_by(pid=pid).first()
    if request.method=="POST":
        email=request.form.get('email')
        fname=request.form.get('fname')
        lname=request.form.get('lname')
        gender=request.form.get('gender')
        slot=request.form.get('slot')
        disease=request.form.get('disease')
        time=request.form.get('time')
        date=request.form.get('date')
        dept=request.form.get('dept')
        phno=request.form.get('phno')
        db.engine.execute(f"UPDATE `patients` SET `email` = '{email}', `fname` = '{fname}',`lname` = '{lname}', `gender` = '{gender}', `slot` = '{slot}', `disease` = '{disease}', `time` = '{time}', `date` = '{date}', `dept` = '{dept}', `phno` = '{phno}' WHERE `patients`.`pid` = {pid}")
        flash("Slot is Updated","success")
        return redirect('/booking')
    return render_template('edit.html',posts=posts)

    


@app.route("/delete/<string:pid>",methods=['POST','GET'])
@login_required
def delete(pid):
    db.engine.execute(f"DELETE FROM `patients` WHERE `patients`.`pid`={pid}")
    flash("Slot Deleted Successful","danger")
    return redirect('/booking')

@app.route("/deletevaccine/<string:vid>",methods=['POST','GET'])
@login_required
def deletevaccine(vid):
    db.engine.execute(f"DELETE FROM `vaccine` WHERE `vaccine`.`vid`={vid}")
    flash("Slot Deleted Successful","danger")
    return redirect('/vaccinbook')     


# @app.route("/deletedoctor/<string:doctorid>",methods=['POST','GET'])
# @login_required
# def deletedoctor(doctorid):
#     db.engine.execute(f"DELETE FROM `doctor` WHERE `doctor`.`doctorid`={doctorid}")
#     flash("Slot Deleted Successful","danger")
#     return redirect('/doctordetails')     


@app.route("/deletetriger/<string:trigerID>",methods=['POST','GET'])
@login_required
def deletetriger(trigerID):
    db.engine.execute(f"DELETE FROM `triger` WHERE `triger`.`trigerID`={trigerID}")
    flash("Slot Deleted Successful","danger")
    return redirect('/triger')  


@app.route("/logoutadmin")
def logoutadmin():
    session.pop('adminemail')
    flash("You are logout admin", "primary")

    return redirect('/adminlogin')
    

@app.route("/signup",methods=['POST','GET'])
def signup():
    if request.method == "POST":
        username=request.form.get('username')
        email=request.form.get('email')
        password=request.form.get('password')
        user=User.query.filter_by(email=email).first()
        if user:
            flash("gmail already exist ,please use different gmail","danger")
            return render_template("/signup.html")
        encpsswrd=generate_password_hash(password)
        new_user=db.engine.execute(f"INSERT INTO `user` (`username`,`email`,`password`) VALUES ('{username}','{email}','{encpsswrd}')")
        flash("signup successful , please login","info")
        return render_template("login.html")
              
    return render_template("signup.html")  


@app.route('/login',methods=['POST','GET'])
def login():
    if request.method == "POST":
        email=request.form.get('email')
        password=request.form.get('password')
        user=User.query.filter_by(email=email).first()

        if user and check_password_hash(user.password,password):
            login_user(user)
            flash("login successful","primary")
            return render_template("index.html")
        else:
            flash("invalid credential","danger")
            return render_template('login.html')

    
    return render_template('login.html')

   
@app.route('/search',methods=['POST','GET'])
@login_required
def search():
    if request.method=="POST":
        query=request.form.get('search')
        dept=Doctor.query.filter_by(ddept=query).first()
        name=Doctor.query.filter_by( dname=query).first()
        if name :

            flash("doctor is Available","success")
        elif dept:

            flash("department is  Available","success")
        else:
            flash("searched doctor or department is not Available ","danger")
    return render_template('patientsbooking.html')


@app.route("/vaccination",methods=['POST','GET'])
@login_required
def bookvaccineslot():

    if request.method=="POST":
        email=request.form.get('email')
        fname=request.form.get('fname')
        lname=request.form.get('lname')
        gender=request.form.get('gender')
        vaccine=request.form.get('vaccine')
        dose=request.form.get('dose')
        age=request.form.get('age')
        slot=request.form.get('slot')
        time=request.form.get('time')
        date=request.form.get('date')
        phno=request.form.get('number')
        new_slot=db.engine.execute(f"INSERT INTO `vaccine` (`email`,`fname`,`lname`,`gender`,`vaccine`,`dose`,`age`,`slot`,`time`,`date`,`phno`) VALUES ('{email}','{fname}','{lname}','{gender}','{vaccine}','{dose}','{age}','{slot}','{time}','{date}','{phno}')")
         
# mail starts from here

        # mail.send_message(subject, sender=params['gmail-user'], recipients=[email],body=f"YOUR bOOKING IS CONFIRMED THANKS FOR CHOOSING US \nYour Entered Details are :\nName: {name}\nSlot: {slot}")



        flash("Booking Confirmed","info")
    return render_template("vaccination.html") 





@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash("logout successful","danger")
    return redirect(url_for('login'))    


@app.route('/triger')
@login_required
def triger():
    #posts=Triger.query.all()
    cemail=current_user.email
    posts=db.engine.execute(f"SELECT * FROM `triger` WHERE email='{cemail}'")  
    return render_template('triger.html',posts=posts)  


if __name__=="__main__":
    app.run(debug=True)       