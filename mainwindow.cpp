#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>
#include <QDebug>
#include <QHeaderView>
#include <QFile>

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent), ui(new Ui::MainWindow)
{
	ui->setupUi(this);
	//this->setStylesheet();
	this->createDatabase();

	tagsTableModel = new QSqlTableModel(this, db);
	tagsTableModel->setTable("S7Tags");
	tagsTableModel->select();
	//tagsTableModel->setHeaderData(0, Qt::Horizontal, tr("Name"));
	//tagsTableModel->setHeaderData(1, Qt::Horizontal, tr("Path"));
	//tagsTableModel->setHeaderData(2, Qt::Horizontal, tr("Parent"));
	ui->tableView->setModel(tagsTableModel);
	ui->tableView->resizeColumnsToContents();

	groupsTableModel = new QSqlTableModel(this, db);
	groupsTableModel->setTable("S7Groups");
	groupsTableModel->select();
	//groupsTableModel->setHeaderData(0, Qt::Horizontal, tr("id"));
	//groupsTableModel->setHeaderData(1, Qt::Horizontal, tr("Name"));
	//groupsTableModel->setHeaderData(2, Qt::Horizontal, tr("Parent"));

	groupingProxy = new QGroupingProxyModel(ui->treeView);
	buildTree();
	groupingProxy->setSourceModel(tagsTableModel);


	//ui->TreeView->setHeader(new QAdvancedHeaderView(Qt::Horizontal, ui->groupingTreeView));
	//ui->treeView->setHeader(new QHeaderView(Qt::Horizontal, ui->treeView));
	ui->treeView->setModel(groupingProxy);
	for(quint8 i = 0; i != ui->treeView->header()->count(); i++) ui->treeView->resizeColumnToContents(i);
	//ui->treeView->setStyleSheet(".branch { background: palette(base) }");
	ui->statusbar->showMessage("Ready");
}

MainWindow::~MainWindow()
{
	delete ui;
}

void MainWindow::buildTree()
{
	struct Group
	{
			quint8 id;
			QString name;
			qint8 parentid;
			bool exist;
	};
	QVector<Group> groups;

	QSqlQuery query(db);
	query.exec("SELECT * FROM S7Groups");

	while(query.next())
	{
		QSqlRecord record = query.record();
		Group tmp;
		tmp.id = record.value("id").toUInt();
		tmp.name = record.value("name").toString();
		tmp.parentid = (!record.value("parent_id").isNull() ? record.value("parent_id").toUInt() : -1);
		tmp.exist = false;
		groups.append(tmp);
		//qDebug() << tmp.id << tmp.name << tmp.parentid;
	}
	qDebug() << groups.size();

	groupingProxy->setModelColumn(3);

	//    QVector<QGroupingProxyModelGroup*> proxyGroups;
	//    foreach(Group tmp, groups)
	//    {
	//        QGroupingProxyModelGroup* tempGroup;
	//        if(tmp.parentid == -1)
	//        {
	//            tempGroup = groupingProxy->addGroup(QIcon(":/icons/folder"), tmp.name, tmp.id);
	//        }
	//        else
	//        {
	//            tempGroup = groupingProxy->addGroup(QIcon(":/icons/folder"), tmp.name, tmp.id, proxyGroups.last());
	//        }
	//        proxyGroups.append(tempGroup);
	//    }
	//    qDebug() << groupingProxy->rowCount();

	QMap<quint8, QGroupingProxyModelGroup*> proxyGroups;
	quint8 count = groups.length();
	do
	{
		for(quint8 i = 0; i != groups.length(); i++)
		{
			QGroupingProxyModelGroup* tempGroup;
			if(groups[i].parentid == -1)
			{
				tempGroup = groupingProxy->addGroup(QIcon(":/icons/folder"), groups[i].name, groups[i].id);
			}
			else
			{
				if(groups[groups[i].parentid].exist == false)
				{
					continue;
				}
				tempGroup = groupingProxy->addGroup(QIcon(":/icons/folder"), groups[i].name, groups[i].id, proxyGroups[groups[i].parentid]);
			}
			groups[i].exist = true;
			count--;
			proxyGroups.insert(groups[i].id, tempGroup);
		}
	}
	while(count != 0);
	qDebug() << proxyGroups.size();


	/*QGroupingProxyModelGroup *group1 = groupingProxy->addGroup(QIcon(":/icons/folder"), "1", "1");
	QGroupingProxyModelGroup *group2 = groupingProxy->addGroup(QIcon(":/icons/folder"), "2", "2");
	QGroupingProxyModelGroup *group3 = groupingProxy->addGroup(QIcon(":/icons/folder"), "3", "3");
	QGroupingProxyModelGroup *group4 = groupingProxy->addGroup(QIcon(":/icons/folder"), "4", "4");
	QGroupingProxyModelGroup *group5 = groupingProxy->addGroup(QIcon(":/icons/folder"), "5", "5");*/
}

void MainWindow::setStylesheet()
{
	QFile file(":/resources/stylesheet.qss");

	if(!file.open(QIODevice::ReadOnly))
	{
		qDebug() << file.errorString();
		return;
	}

	qApp->setStyleSheet(QString(file.readAll()));

}

void MainWindow::createDatabase()
{
	QSqlDatabase::database("in_mem_db", false).close();
	QSqlDatabase::removeDatabase("in_mem_db");
	db = QSqlDatabase::addDatabase("QSQLITE", "in_mem_db");
	db.setDatabaseName(":memory:");
	db.commit();
	if(!db.open()) QMessageBox::warning(this, tr("Unable to open database"), db.lastError().text());

	QSqlQuery query(db);
	QFile file(":/resources/query.sql");

	if(!file.open(QIODevice::ReadOnly))
	{
		qDebug() << file.errorString();
		return;
	}

	while(!file.atEnd())
	{
		QByteArray line = file.readLine();
		if(line.length() < 3) continue;

		query.exec(line);
	}

}
