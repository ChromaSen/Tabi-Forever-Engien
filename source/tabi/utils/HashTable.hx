package tabi.utils;

class HashTable<K, V>
{
	private var _size:Int;
	private var _capacity:Int;
	private var _buckets:haxe.ds.Vector<Array<{key:K, value:V}>>;

	public function new()
	{
		_size = 0;
		_capacity = 16;
		_buckets = new haxe.ds.Vector<Array<{key:K, value:V}>>(_capacity);
	}

	private function hash(key:K):Int
	{
		var strKey:String = Std.string(key);
		var hash:Int = 0;
		for (i in 0...strKey.length)
		{
			hash = (hash << 5) + hash + strKey.charCodeAt(i);
		}
		return hash % _capacity;
	}

	public function put(key:K, value:V):Void
	{
		var index:Int = hash(key);
		if (_buckets[index] == null)
		{
			_buckets[index] = new Array<{key:K, value:V}>();
		}
		for (pair in _buckets[index])
		{
			if (pair.key == key)
			{
				pair.value = value;
				return;
			}
		}
		_buckets[index].push({key: key, value: value});
		_size++;
	}

	public function get(key:K):Null<V>
	{
		var index:Int = hash(key);
		if (_buckets[index] == null)
		{
			return null;
		}
		for (pair in _buckets[index])
		{
			if (pair.key == key)
			{
				return pair.value;
			}
		}
		return null;
	}

	public function remove(key:K):Void
	{
		var index:Int = hash(key);
		if (_buckets[index] == null)
		{
			return;
		}
		for (i in 0..._buckets[index].length)
		{
			if (_buckets[index][i].key == key)
			{
				_buckets[index].splice(i, 1);
				_size--;
				return;
			}
		}
	}

	public function containsKey(key:K):Bool
	{
		return get(key) != null;
	}

	public function getSize():Int
	{
		return _size;
	}
}
