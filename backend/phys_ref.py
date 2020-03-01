import json

class phys_reference:


    def __init__(self):
        try:
            with open('phys_reference.json', 'r+') as json_file:
                self.ref_list = json.load(json_file)
        except:
            raise ValueError("FILE MALFORMED/MISSING: phys_reference.json")
        try:
            with open('sizes.json', 'r+') as json_file:
                self.size_list = json.load(json_file)
        except:
            raise ValueError("FILE MALFORMED/MISSING: sizes.json")

        self.CHEST_ABS_PIX = 618
        self.NECK_ABS_PIX = 274


    def get_length_inches(self, currency, denomination):
        return self.get_length(currency, denomination, 'inches')


    def get_length_cm(self, currency, denomination):
        return self.get_length(currency, denomination, 'cm')


    def get_length(self, currency, denomination, unit):
        try:
            for ref in self.ref_list:
                if (ref['currency'] == currency and ref['denomination'] == denomination):
                    return float(ref[unit])
            raise NotImplementedError
        except:
            raise ValueError(f'PARAMS: {currency} , {denomination} not in database')


    # may eventually define post_dict {onhuman: bool, reference: , unit}
    def get_size(self, image, ref_pix, currency, denomination): 
        ref_length = self.get_length_inches(currency, denomination)
        img_chest = (float(self.CHEST_ABS_PIX) / float(ref_pix)) * ref_length
        for size in self.size_list:
            if (img_chest < float(size['chest_size']['inches'].split('-')[1])): # upper bound
                if (img_chest > float(size['chest_size']['inches'].split('-')[0])): # lower bound
                    return size['size']

        return 'UNKNOWN'

if __name__ == '__main__':
    ph = phys_reference()
    for i in range(1,100,1):
        print(i, " yields ", ph.get_size(None, i, 'USD', '1'))
