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

    def get_length_inches(self, currency, denom):
        return self.get_length(currency, denom, 'inches')


    def get_length_cm(self, currency, denom):
        return self.get_length(currency, denom, 'cm')
    

    def get_length(self, currency, denom, unit):
        try:
            for ref in self.ref_list:
                if (ref['currency'] == currency and ref['denomination'] == denom):
                    return float(ref[unit])
            raise NotImplementedError
        except:
            raise ValueError(f'PARAMS: {currency} , {denom} not in database')

    # may eventually define post_dict {onhuman: bool, ref_pix: size, currency: curr, denomination: denom, unit: inches}
    def interpret_pix_size(self, ref_pix, currency, denom): 
        img_chest = self.chest_size(ref_pix, currency, denom)

        for size in self.size_list:
            if (img_chest < float(size['chest_size']['inches'].split('-')[1])): # upper bound
                if (img_chest > float(size['chest_size']['inches'].split('-')[0])): # lower bound
                    return {'size_name':size['size'],'chest_length':img_chest}
                    
        raise NotImplementedError

    def chest_size(self, ref_pix, currency, denom):
        ref_length = self.get_length_inches(currency, denom)
        return (float(self.CHEST_ABS_PIX) / float(ref_pix)) * ref_length
    
# if __name__ == '__main__':
#     ph = phys_reference()
#     for i in range(1,100,1):
#         print(i, " yields ", ph.get_size(i, 'USD', '1'))
