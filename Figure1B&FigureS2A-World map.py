import pandas as pd
import folium, branca,os
from folium.features import DivIcon
import geopandas
import matplotlib
import matplotlib.pylab as plt
import numpy as np
import branca.colormap as cm
import pdfkit
df = pd.read_excel(r"D:\folium_documentation-main\data.xlsx")
df.loc[df.CountryName=='China','Count']= df.loc[df.CountryName.isin(['China','Hong Kong','Taiwan','Macao']),'Count'].sum()
df=df.loc[~ df.CountryName.isin(['Hong Kong','Taiwan','Macao'])]
#为了使数据中的国家名字与后面的地图数据中的国家名字匹配，需要将部分国家的名字替换为地图数据中的名字
df.CountryName.replace({'Iran, Islamic Republic of...':'Iran',
                       'Russian Federation':'Russia','Sri Lanka':'Srilanka',
                       'Venezuela, Bolivarian Republic of...':'Venezuela',
                       'The former Yugoslav Republic of Macedonia':'North Macedonia','Syrian Arab Republic':'Syria',
                        'Brunei Darussalam':'Brunei','Republic of Moldova':'Moldova',
                        'Congo, Democratic Republic':'Dem. Rep. Congo',"Lao People's Democratic Republic":'Laos',
                        'Libyan Arab Jamahiriya':'Libya','South Sudan':'S. Sudan',
                       'United Republic of Tanzania':'Tanzania',
                        'Bosnia and Herzegovina':'Bosnia And Herzegovina',"Korea,Democratic People'S Republic Of":'North Korea',
                       },
                       inplace=True)
print(df.CountryName.unique())

# Read the geopandas dataset
data = geopandas.read_file("世界国家.shp")
data.crs="epsg:4326"
data.to_crs(crs="epsg:3857")
data.to_file('World.geojson', driver='GeoJSON')
#国家名字每个单词首字母大写
data.NAME=data.NAME.apply(lambda x:x.title() if not pd.isna(x) else np.nan)
data.NAME.replace({'Russian Federation':'Russia','Cote D¡¯Ivoire':"Cote D'Ivoire'",
                  "Korea,Democratic People'S Republic Of":'North Korea',
                   'Macedonia,The Former Yugoslav Republic Of':'North Macedonia',
                   'Syrian Arab Republic':'Syria','Korea, Republic Of':'South Korea',
                   'Congo,The Democratic Republic Of The':'Dem. Rep. Congo',
                   'United States of America':'United States'
                  },inplace=True)
#将下载量数据中的国家名字也做同样的处理
df.CountryName=df.CountryName.apply(lambda x:x.title() if not pd.isna(x) else np.nan)
#把两个数据框拼接起来，拼接后的数据框，既包含世界地图坐标数据，也包含我们需要展示的数据（下载量）
data = data.merge(df, how="left", left_on=['NAME'], right_on=['CountryName'])
print(data.NAME.unique())
data.drop('geometry',axis=1).head()
#geometry这一列包含每个国家的坐标和边界信息，非常庞大，所以就不展示geometry这一列了

df.loc[~ df.CountryName.isin(data.NAME.tolist())].CountryName.values

my_map = folium.Map(title="World Map",location=(50,5),max_zoom=1,control_scale=True,
                    zoom_control=False,width='80%',height='90%',zoom_start=2.49,#tiles='Stamen Terrain', #Stamen Watercolor
                    # titles="http://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineCommunityENG/MapServer/tile/{z}/{y}/{x}",
                   tiles=folium.TileLayer('https://{s}.tile.thunderforest.com/mobile-atlas/{z}/{x}/{y}.png?apikey={apikey}',
                          attr='&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
                          apikey='pk.eyJ1IjoiZGluZ3diIiwiYSI6ImNsY3doNmluazBmd2Qzb29lbzVrYXltdjYifQ.H8sWvLIDzRD7hbZDYlbUCQ',maxZoom=24,overlay=True)
                   )



data['Y']=data.Count.apply(lambda x:np.log2(x+1) if not pd.isna(x) else np.nan)
max_v = data.Y.max()
def get_color(x,name):
    if pd.isna(name):
        return 'darkgrey'
    if pd.isna(x):
        return 'darkgrey'
    return matplotlib.colors.rgb2hex(plt.get_cmap('Spectral_r')(x/max_v))
    # return cmap(x)

ticks=[]
for i in np.arange(start=0,stop=1.1,step=0.1):
    ticks.append(int(2**(i * max_v) -1))
print(ticks)
cmap = cm.LinearColormap([plt.get_cmap('Spectral_r')(i) for i in np.arange(start=0,stop=1.1,step=0.1)],
                         index=np.arange(start=0,stop=1.1,step=0.1),vmin=0, vmax=1,max_labels=20).to_step(10) #tick_labels=ticks,

cmap.caption="Number of download"
my_map.add_child(cmap)

# add different color to each country according to the number of download

folium.GeoJson(
    data,
    style_function=lambda feature: {
        'fillColor': get_color(feature['properties']['Y'],feature['properties']['NAME']),
        'color': 'grey',
        'fillOpacity':1,
        'opacity':0.7,
        'weight': 1,
        'dashArray': '0.8, 0.8'
    }
).add_to(my_map)

my_map.save('map1.html')
my_map

from branca.element import Element
e = Element("""
  var ticks = document.querySelectorAll('div.legend g.tick text')
  for(var i = 0; i < ticks.length; i++) {
    var value = parseFloat(ticks[i].textContent.replace(',', ''))
    console.log(value)
    var newvalue = (Math.pow(2, value * 15.939188921332656).toFixed(0)-1).toString()
    ticks[i].textContent = newvalue
  }
""")
html = cmap.get_root()
html.script.get_root().render()
html.script.add_child(e)
#如果需要保存成html可以添加
my_map.save('map2.html')
my_map
pdfkit.from_file('map2.html', 'map2.pdf')