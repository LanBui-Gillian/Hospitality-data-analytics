import pandas as pd
import pyodbc as db

df = pd.read_csv("fact_bookings.csv")

PATH_ = r"C:\Users\USER\Downloads\multi_dataset\HospitalityDataAnalysisP"
with open(PATH_ + "\last_sync.txt","r") as file:
    lastDate_sync = file.read()
    
df['booking_date'] = pd.to_datetime(df['booking_date'])
df = df.loc[df.booking_date > pd.Timestamp(lastDate_sync)]

# print(df.dtypes)

# Assign values to variables
booking_id = df['booking_id']
property_id = df['property_id']
booking_date = df['booking_date']
check_in_date = df['check_in_date']
checkout_date = df['checkout_date']
no_guests = df['no_guests']
room_category = df['room_category']
booking_platform = df['booking_platform']
ratings_given = df['ratings_given']
booking_status = df['booking_status']
revenue_generated = df['revenue_generated']
revenue_realized = df['revenue_realized']

# Transform data and make it match in SQL Server
ratings_given=ratings_given.fillna(0).round(2)

# Connect and Load Data
SQL_conn = db.connect('Driver={SQL Server Native Client 11.0};'
                               'Server=GILLIANB;'
                               'Database=DB_HotelManagement;'
                               'Trusted_Connection=yes;')

cursor = SQL_conn.cursor()

for a,b,c,d,e,f,g,h,i,j,k,l in zip(booking_id,property_id,booking_date,check_in_date,checkout_date,no_guests,room_category,booking_platform,ratings_given,booking_status,revenue_generated,revenue_realized):
    query = '''INSERT INTO [dbo].[source_table_bookings]([booking_id],[property_id],[booking_date],[check_in_date],[checkout_date],[no_guests],[room_category],[booking_platform],[ratings_given],[booking_status],[revenue_generated],[revenue_realized]) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)'''
    data_tuple = (a,b,c,d,e,f,g,h,i,j,k,l)
    cursor.execute(query, data_tuple)
    
# Commit
cursor.commit()

cursor.close()

lastDate_sync = max(booking_date)
with open(PATH_ + "\last_sync.txt","w") as file:
    file.write(f'{lastDate_sync}')