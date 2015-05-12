#ifndef WAREHOUSE_H__
#define WAREHOUSE_H__

class Warehouse {
private:
	int stock;
public:
	Warehouse();
	void putGoods(int amount);
	int takeGoods(int amount);
	int getStock();
};

#endif

