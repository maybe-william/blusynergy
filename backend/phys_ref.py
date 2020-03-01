import json

class phys_reference():
    
    def __init__(self):
        try:
            with open('phys_reference.json', 'r+') as json_file:
                self.ref_list = json.load(json_file)
        except:
            raise ValueError("FILE MALFORMED/MISSING: phys_reference.json")

    def get_measure_inches(self, currency, denomination):
        return self.get_length(currency, denomination, 'inches')

    def get_measure_cm(self, currency, denomination):
        return self.get_length(currency, denomination, 'cm')
    
    def get_length(self, currency, denomination, unit):
        try:
            return([x for x in self.ref_list if (x['currency'] == currency and x['denomination'] == denomination)][0][unit])
        except:
            raise ValueError('PARAMS: does not exist')

print(phys_reference().get_measure_cm("USD","1"))