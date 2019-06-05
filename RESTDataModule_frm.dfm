object RESTDataModule: TRESTDataModule
  OldCreateOrder = False
  Height = 214
  Width = 238
  object RESTClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8443/'
    ContentType = 'application/x-www-form-urlencoded'
    Params = <>
    Left = 48
    Top = 8
  end
  object Request: TRESTRequest
    Client = RESTClient
    Method = rmPUT
    Params = <>
    Response = Response
    SynchronizedEvents = False
    Left = 48
    Top = 56
  end
  object Response: TRESTResponse
    Left = 48
    Top = 104
  end
end
