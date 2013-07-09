import urllib2
from bs4 import BeautifulSoup

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

address = 'http://en.wikipedia.org/wiki/Federal_Information_Processing_Standard_state_code'
req = urllib2.Request(address,headers = {'User-Agent':"Magic Browser"})
response = urllib2.urlopen(req).read()

soup = BeautifulSoup(response)
table = soup.find('table', {'class':'wikitable sortable'})
rows = table.findAll('tr')
for tr in rows:
	cols = tr.findAll('td')
	change = 0
	for td in cols:
		try:
			text = ''.join(td.find(text=True))
		except:
			continue
		else:
			if is_number(text) == False:
				if len(text) == 2:
					state = text
					change = 1
				else:
					continue
			else:
				code = int(text)
	try:
		if change == 1:
			print "nfp_demographics$nfp_state_recode[nfp_centers$State == '%s'] = %d" % (state,code)
	except:
		continue


