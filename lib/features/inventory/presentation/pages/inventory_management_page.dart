import 'package:flutter/material.dart';

class InventoryManagementPage extends StatefulWidget {
  const InventoryManagementPage({super.key});

  @override
  State<InventoryManagementPage> createState() => _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  final List<AssetItem> _assets = [
    AssetItem(id: 1, name: 'Projector', type: 'Lab Equipment', condition: 'Good', quantity: 3),
    AssetItem(id: 2, name: 'Football', type: 'Sports Equipment', condition: 'Good', quantity: 20),
    AssetItem(id: 3, name: 'Microscope', type: 'Lab Equipment', condition: 'Needs Repair', quantity: 2),
  ];

  final List<AssetItem> _labEquipment = [];
  final List<AssetItem> _sportsEquipment = [];
  final List<AssetStock> _stockHistory = [];

  @override
  void initState() {
    super.initState();
    _labEquipment.addAll(_assets.where((asset) => asset.type == 'Lab Equipment'));
    _sportsEquipment.addAll(_assets.where((asset) => asset.type == 'Sports Equipment'));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventory Management'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Assets'),
              Tab(text: 'Lab Equipment'),
              Tab(text: 'Sports'),
              Tab(text: 'Stock'),
              Tab(text: 'Reports'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAssetTab(context),
            _buildLabEquipmentTab(context),
            _buildSportsEquipmentTab(context),
            _buildStockManagementTab(context),
            _buildReportsTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, {VoidCallback? action, String? actionLabel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          if (action != null && actionLabel != null)
            ElevatedButton(onPressed: action, child: Text(actionLabel)),
        ],
      ),
    );
  }

  Widget _buildAssetTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Asset Management', 'Add and manage all school assets.', action: () => _showAssetDialog(context), actionLabel: 'Add Asset'),
        Expanded(
          child: _assets.isEmpty
              ? const Center(child: Text('No assets available yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _assets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final asset = _assets[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(asset.name),
                        subtitle: Text('${asset.type} • ${asset.condition} • Qty: ${asset.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showAssetDialog(context, asset: asset)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _deleteAsset(asset))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildLabEquipmentTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Lab Equipment', 'Track lab supplies and devices.', action: () => _showAssetDialog(context, category: 'Lab Equipment'), actionLabel: 'Add Lab Item'),
        Expanded(
          child: _labEquipment.isEmpty
              ? const Center(child: Text('No lab equipment recorded.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _labEquipment.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final asset = _labEquipment[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(asset.name),
                        subtitle: Text('${asset.condition} • Qty: ${asset.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showAssetDialog(context, asset: asset)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _deleteAsset(asset))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSportsEquipmentTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Sports Equipment', 'Manage sports gear and inventory.', action: () => _showAssetDialog(context, category: 'Sports Equipment'), actionLabel: 'Add Sports Item'),
        Expanded(
          child: _sportsEquipment.isEmpty
              ? const Center(child: Text('No sports equipment recorded.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _sportsEquipment.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final asset = _sportsEquipment[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(asset.name),
                        subtitle: Text('${asset.condition} • Qty: ${asset.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showAssetDialog(context, asset: asset)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _deleteAsset(asset))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStockManagementTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Stock Management', 'Update stock levels, damaged items and movements.', action: () => _showStockDialog(context), actionLabel: 'Record Stock'),
        Expanded(
          child: _stockHistory.isEmpty
              ? const Center(child: Text('No stock activity recorded.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _stockHistory.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = _stockHistory[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(entry.assetName),
                        subtitle: Text('${entry.action} • Qty: ${entry.quantity} • ${entry.date}'),
                        trailing: Text(entry.notes),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildReportsTab(BuildContext context) {
    final availableAssets = _assets.where((asset) => asset.condition.toLowerCase() == 'good').toList();
    final damagedAssets = _assets.where((asset) => asset.condition.toLowerCase() != 'good').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Inventory Reports', 'Review available assets, damaged items and history.'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ReportCard(title: 'Available Assets', value: '${availableAssets.length}'),
              _ReportCard(title: 'Damaged Assets', value: '${damagedAssets.length}'),
              _ReportCard(title: 'History Entries', value: '${_stockHistory.length}'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Available Assets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...availableAssets.map((asset) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(asset.name),
                  subtitle: Text('${asset.type} • Qty: ${asset.quantity}'),
                  trailing: Text(asset.condition),
                ),
              )),
          const SizedBox(height: 24),
          const Text('Damaged Assets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          damagedAssets.isEmpty
              ? const Text('No damaged assets at this time.')
              : Column(
                  children: damagedAssets
                      .map((asset) => Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(asset.name),
                              subtitle: Text('${asset.type} • Qty: ${asset.quantity}'),
                              trailing: Text(asset.condition),
                            ),
                          ))
                      .toList(),
                ),
          const SizedBox(height: 24),
          const Text('Asset History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _stockHistory.isEmpty
              ? const Text('No asset history available.')
              : Column(
                  children: _stockHistory
                      .map((entry) => Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(entry.assetName),
                              subtitle: Text('${entry.action} • Qty ${entry.quantity} • ${entry.date}'),
                              trailing: Text(entry.notes),
                            ),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }

  void _showAssetDialog(BuildContext context, {AssetItem? asset, String? category}) {
    final nameController = TextEditingController(text: asset?.name ?? '');
    final quantityController = TextEditingController(text: asset?.quantity.toString() ?? '');
    String selectedType = asset?.type ?? category ?? 'Asset Management';
    final conditionController = TextEditingController(text: asset?.condition ?? 'Good');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(asset == null ? 'Add Asset' : 'Edit Asset'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Asset Name')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: const [
                  DropdownMenuItem(value: 'Asset Management', child: Text('General Asset')),
                  DropdownMenuItem(value: 'Lab Equipment', child: Text('Lab Equipment')),
                  DropdownMenuItem(value: 'Sports Equipment', child: Text('Sports Equipment')),
                ],
                decoration: const InputDecoration(labelText: 'Type'),
                onChanged: (value) => selectedType = value ?? selectedType,
              ),
              const SizedBox(height: 8),
              TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: conditionController, decoration: const InputDecoration(labelText: 'Condition')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
              final condition = conditionController.text.trim();
              if (name.isEmpty || quantity <= 0 || condition.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid asset data.')));
                return;
              }
              setState(() {
                if (asset != null) {
                  asset.name = name;
                  asset.type = selectedType;
                  asset.quantity = quantity;
                  asset.condition = condition;
                } else {
                  final newAsset = AssetItem(
                    id: _assets.isEmpty ? 1 : _assets.last.id + 1,
                    name: name,
                    type: selectedType,
                    condition: condition,
                    quantity: quantity,
                  );
                  _assets.add(newAsset);
                  if (selectedType == 'Lab Equipment') {
                    _labEquipment.add(newAsset);
                  } else if (selectedType == 'Sports Equipment') {
                    _sportsEquipment.add(newAsset);
                  }
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showStockDialog(BuildContext context) {
    final quantityController = TextEditingController();
    final notesController = TextEditingController();
    String selectedAsset = _assets.isNotEmpty ? _assets.first.name : '';
    String selectedAction = 'Added';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Stock Movement'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedAsset.isNotEmpty ? selectedAsset : null,
                items: _assets.map((asset) => DropdownMenuItem(value: asset.name, child: Text(asset.name))).toList(),
                decoration: const InputDecoration(labelText: 'Asset'),
                onChanged: (value) => selectedAsset = value ?? selectedAsset,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedAction,
                items: const [
                  DropdownMenuItem(value: 'Added', child: Text('Added')),
                  DropdownMenuItem(value: 'Removed', child: Text('Removed')),
                  DropdownMenuItem(value: 'Damaged', child: Text('Damaged')),
                ],
                decoration: const InputDecoration(labelText: 'Action'),
                onChanged: (value) => selectedAction = value ?? selectedAction,
              ),
              const SizedBox(height: 8),
              TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: notesController, decoration: const InputDecoration(labelText: 'Notes')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
              final notes = notesController.text.trim();
              if (selectedAsset.isEmpty || quantity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid stock details.')));
                return;
              }
              setState(() {
                _stockHistory.add(AssetStock(
                  id: _stockHistory.isEmpty ? 1 : _stockHistory.last.id + 1,
                  assetName: selectedAsset,
                  action: selectedAction,
                  quantity: quantity,
                  notes: notes.isEmpty ? 'No notes' : notes,
                  date: DateTime.now().toString().split(' ').first,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Record'),
          ),
        ],
      ),
    );
  }

  void _deleteAsset(AssetItem asset) {
    _assets.remove(asset);
    _labEquipment.removeWhere((item) => item.id == asset.id);
    _sportsEquipment.removeWhere((item) => item.id == asset.id);
  }
}

class AssetItem {
  AssetItem({required this.id, required this.name, required this.type, required this.condition, required this.quantity});

  final int id;
  String name;
  String type;
  String condition;
  int quantity;
}

class AssetStock {
  AssetStock({required this.id, required this.assetName, required this.action, required this.quantity, required this.notes, required this.date});

  final int id;
  final String assetName;
  final String action;
  final int quantity;
  final String notes;
  final String date;
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;

  const _ReportCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 12),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
