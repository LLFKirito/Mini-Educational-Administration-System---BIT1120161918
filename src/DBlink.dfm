object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 184
  Width = 385
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLNCLI11.1;Integrated Security=SSPI;Persist Security I' +
      'nfo=False;User ID="";Initial Catalog=MiniEduSystem;Data Source=.' +
      ';Initial File Name="";Server SPN=""'
    LoginPrompt = False
    Provider = 'SQLNCLI11.1'
    Left = 64
    Top = 80
  end
  object ADOQuery1: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Student')
    Left = 176
    Top = 48
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 280
    Top = 48
  end
  object ADOQuery2: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Student')
    Left = 176
    Top = 112
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 280
    Top = 112
  end
end
