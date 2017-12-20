#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtSql>
#include <QSqlQuery>
#include <QSqlTableModel>
#include "qgroupingproxymodel.h"

namespace Ui
{
	class MainWindow;
}

class MainWindow : public QMainWindow
{
		Q_OBJECT

	public:
		explicit MainWindow(QWidget *parent = 0);
		~MainWindow();
		void setStylesheet();
		void createDatabase();

	private:
		Ui::MainWindow *ui;
		QSqlTableModel *tagsTableModel;
		QSqlTableModel *groupsTableModel;
		QGroupingProxyModel* groupingProxy;
		//QSqlQueryModel *groupsQueryModel;
		QSqlDatabase db;

		void buildTree();
};

#endif // MAINWINDOW_H
