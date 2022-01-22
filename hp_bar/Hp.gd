extends TextureProgress

var data

func init(data):
	self.data = data
	self.max_value = data.max_hp
	self.value = data.current_hp
	$Layout/MaxValue.text = String(data.max_hp)
	$Layout/CurrentValue.text = String(data.current_hp)
