#ifndef QGROUPINGPROXYMODEL_H
#define QGROUPINGPROXYMODEL_H

#include <QAbstractProxyModel>

class QGroupingProxyModelGroup;
class QGroupingProxyModelPrivate;

class QGroupingProxyModel : public QAbstractItemModel
{
		Q_OBJECT
		Q_PROPERTY(bool groupsSpanned READ groupsSpanned WRITE setGroupsSpanned)
		Q_PROPERTY(int modelColumn READ modelColumn WRITE setModelColumn)

	public:
		explicit QGroupingProxyModel(QObject *parent = 0);
		~QGroupingProxyModel();
		QGroupingProxyModelGroup* addGroup(const QString & text, const QVariant & value = QVariant(), QGroupingProxyModelGroup* parent = nullptr);
		QGroupingProxyModelGroup* addGroup(const QIcon & icon, const QString & text, const QVariant & value = QVariant(), QGroupingProxyModelGroup* parent = nullptr);
		int columnCount(const QModelIndex & parent = QModelIndex()) const;
		QVariant data(const QModelIndex & proxyIndex, int role) const;
		Qt::ItemFlags flags(const QModelIndex & index) const;
		bool groupsSpanned() const;
		QVariant headerData(int section, Qt::Orientation orientation, int role) const;
		QModelIndex index(int row, int column, const QModelIndex & parent = QModelIndex()) const;

		int findText(const QString & text) const;
		QModelIndex mapFromSource(const QModelIndex & sourceIndex) const;
		QModelIndex mapToSource(const QModelIndex & proxyIndex) const;
		int modelColumn() const;
		QModelIndex parent(const QModelIndex & child) const;
		bool removeGroup(int index);
		bool restoreGroups(const QByteArray & data);
		int rowCount(const QModelIndex & parent = QModelIndex()) const;
		QByteArray saveGroups() const;
		bool setData(const QModelIndex & index, const QVariant &value, int role);

		void setGroupSectionHeader(const QString & header);
		void setGroupsSpanned(bool on);
		void setModelColumn(int column);
		virtual void setSourceModel( QAbstractItemModel* sourceModel );
		void setUngroupedItemTitle(const QString & title);
		void setUngroupedItemTitle(const QString & title, const QIcon & icon);
		virtual QSize span(const QModelIndex & index) const;

	private slots:
		void dataChangedHandler(const QModelIndex & topLeft, const QModelIndex & bottomRight);
		void sourceModelResetHandler();
		void rowsAboutToBeInsertedHandler( const QModelIndex & parent, int start, int end );
		void rowsInsertedHandler(const QModelIndex & parent, int first, int last);

	private:
		void buildGroups();

		int groupAt(int sourceModelRow);
		void moveRows(int row, int count);
		void removeSourceModelRow(int sourceModelRow);

		QString m_groupSectionHeader;
		QGroupingProxyModelGroup* m_groupUngroupedItem;
		QGroupingProxyModelPrivate* d;
};

class QGroupingProxyModelGroup
{
	public:
		QGroupingProxyModelGroup(QGroupingProxyModelGroup* parent = 0);
		QGroupingProxyModelGroup(int sourceModelRow, QGroupingProxyModelGroup* parent = 0);
		QGroupingProxyModelGroup(const QString & name, QGroupingProxyModelGroup* parent = 0);
		~QGroupingProxyModelGroup();

		void addSourceModelRow(int row);
		void clear();
		QGroupingProxyModelGroup* child(int index) const;
		int childCount() const;
		QVariant data(int role) const;
		QGroupingProxyModelGroup* findSourceModelRow(int sourceModelRow) const;
		QGroupingProxyModelGroup *group(int sourceModelRow) const;
		int indexOf(QGroupingProxyModelGroup* group) const;
		int sourceModelRowIndexAt(int sourceModelRow) const;
		QGroupingProxyModelGroup* matches(const QVariant & value) const;
		void moveSourceRow(int count);
		QGroupingProxyModelGroup* parent() const;
		void removeChild(int index);
		void removeChildAtSourceModelRow(int sourceModelRow);
		void removeSourceModelRow(int row);
		int row() const;
		int row(int sourceModelRow) const;
		void setData(const QVariant & data, int role);
		int sourceModelRow() const;
		QList<int> sourceModelRows() const;

	private:
		QList<QGroupingProxyModelGroup*> cChildren;
		QMap<int, QVariant> cData;
		QGroupingProxyModelGroup* cParent;
		int cSourceModelRow;
		QList<int> cSourceModelRows;
};

class QGroupingProxyModelPrivate
{
	public:
		QGroupingProxyModelPrivate(QGroupingProxyModel* pm);
		~QGroupingProxyModelPrivate();

		bool groupsSpanned;
		int modelColumn;
		int groupItemDataRole;
		QGroupingProxyModelGroup* root;
		QAbstractItemModel* sourceModel;

		QGroupingProxyModel* m;
};

#endif // QGROUPINGPROXYMODEL_H
