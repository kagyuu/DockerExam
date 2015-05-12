#include "warehouse.h"

Warehouse::Warehouse() {
	stock = 0;
}

void Warehouse::putGoods(int amount){
	stock += amount;
}

int Warehouse::takeGoods(int amount){
	if (stock >= amount) {
		stock -= amount;
		return amount;
	}
	int tmp;
	tmp = stock;
	stock = 0;
	return tmp;
}

int Warehouse::getStock() {
	return stock;
}
