from pandas_datareader.data import DataReader
from datetime import datetime
import matplotlib.pyplot as plt


# in the following order, shenhua, chinacoal, datong, yanzhou, yitai
coalStock = {'Shenhua':'601088.SS',
             'ChinaCoal':'601898.SS',
             'Datong':'601001.SS',
             'Yanzhou':'600188.SS',
             'Yitai':'900948.SS'}

stockInfo = DataReader(list(coalStock.values()),  'yahoo', datetime(2010,1,1), datetime(2015,1,1))

filePath = 'C://Users//User\Desktop//test.txt'


# stockInfo contains 3 dimension, the last one is for different companies.
# write those to txt, in order to copy to excel
stockInfo[:,:,0].to_csv(filePath)
print(stockInfo)
