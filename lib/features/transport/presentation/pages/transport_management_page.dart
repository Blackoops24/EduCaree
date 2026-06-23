import 'package:flutter/material.dart';

class TransportManagementPage extends StatefulWidget {
  const TransportManagementPage({super.key});

  @override
  State<TransportManagementPage> createState() => _TransportManagementPageState();
}

class _TransportManagementPageState extends State<TransportManagementPage> {
  final List<Vehicle> _vehicles = [
    Vehicle(id: 1, name: 'Bus A1', registration: 'KA01AB1234', capacity: 40, assignedRoute: 'Route 1'),
    Vehicle(id: 2, name: 'Van V2', registration: 'KA05CD5678', capacity: 18, assignedRoute: 'Route 3'),
  ];

  final List<Driver> _drivers = [
    Driver(id: 1, name: 'Ramesh Kumar', license: 'DL-123456789', phone: '9876543210', assignedVehicle: 'Bus A1'),
    Driver(id: 2, name: 'Sonal Patel', license: 'DL-987654321', phone: '9123456780', assignedVehicle: 'Van V2'),
  ];

  final List<TransportRoute> _routes = [
    TransportRoute(id: 1, name: 'Route 1', stops: 'Main Gate → Block A → Block B → Lake View', distance: '12 km'),
    TransportRoute(id: 2, name: 'Route 2', stops: 'Main Gate → Science Park → North Colony', distance: '9 km'),
    TransportRoute(id: 3, name: 'Route 3', stops: 'Main Gate → East Market → Riverside', distance: '15 km'),
  ];

  final List<StudentAssignment> _assignments = [
    StudentAssignment(id: 1, studentName: 'Anika Shah', vehicle: 'Bus A1', route: 'Route 1'),
    StudentAssignment(id: 2, studentName: 'Rohan Iyer', vehicle: 'Van V2', route: 'Route 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transport Management'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Vehicles'),
              Tab(text: 'Drivers'),
              Tab(text: 'Routes'),
              Tab(text: 'Allocations'),
              Tab(text: 'Tracking'),
              Tab(text: 'Reports'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildVehiclesTab(context),
            _buildDriversTab(context),
            _buildRoutesTab(context),
            _buildAllocationsTab(context),
            _buildTrackingTab(context),
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

  Widget _buildVehiclesTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Vehicle Management', 'Add, edit and manage fleet details.', action: () => _showVehicleDialog(context), actionLabel: 'Add Vehicle'),
        Expanded(
          child: _vehicles.isEmpty
              ? const Center(child: Text('No vehicles registered yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _vehicles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final vehicle = _vehicles[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(vehicle.name),
                        subtitle: Text('${vehicle.registration} • Capacity ${vehicle.capacity} • ${vehicle.assignedRoute}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showVehicleDialog(context, vehicle: vehicle)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _vehicles.removeAt(index))),
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

  Widget _buildDriversTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Driver Management', 'Keep driver records and assignments.', action: () => _showDriverDialog(context), actionLabel: 'Add Driver'),
        Expanded(
          child: _drivers.isEmpty
              ? const Center(child: Text('No drivers registered yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _drivers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final driver = _drivers[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(driver.name),
                        subtitle: Text('${driver.license} • ${driver.phone} • ${driver.assignedVehicle}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showDriverDialog(context, driver: driver)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _drivers.removeAt(index))),
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

  Widget _buildRoutesTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Route Management', 'Manage transport routes and stops.', action: () => _showRouteDialog(context), actionLabel: 'Add Route'),
        Expanded(
          child: _routes.isEmpty
              ? const Center(child: Text('No routes have been defined yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _routes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final route = _routes[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(route.name),
                        subtitle: Text('${route.stops} • ${route.distance}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showRouteDialog(context, route: route)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _routes.removeAt(index))),
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

  Widget _buildAllocationsTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Student Allocation', 'Assign students to vehicles and routes.', action: () => _showAllocationDialog(context), actionLabel: 'Allocate Student'),
        Expanded(
          child: _assignments.isEmpty
              ? const Center(child: Text('No student allocations created yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _assignments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final assignment = _assignments[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(assignment.studentName),
                        subtitle: Text('${assignment.vehicle} • ${assignment.route}'),
                        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _assignments.removeAt(index))),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTrackingTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('GPS Tracking', 'Live vehicle tracking and route monitoring.'),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blueGrey.shade50,
              ),
              child: const Center(
                child: Text('Google Maps integration placeholder for live GPS tracking', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black54)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Route Monitoring', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Track active routes and vehicle positions on the map in real time.'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _routes
                        .map((route) => Chip(
                              label: Text(route.name),
                              avatar: const Icon(Icons.map, size: 18),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab(BuildContext context) {
    final totalVehicles = _vehicles.length;
    final totalDrivers = _drivers.length;
    final totalRoutes = _routes.length;
    final totalAllocations = _assignments.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Transport Reports', 'View status of vehicles, drivers, routes and allocations.'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ReportCard(title: 'Vehicles', value: '$totalVehicles'),
              _ReportCard(title: 'Drivers', value: '$totalDrivers'),
              _ReportCard(title: 'Routes', value: '$totalRoutes'),
              _ReportCard(title: 'Allocations', value: '$totalAllocations'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Active Routes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._routes.map((route) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(route.name),
                  subtitle: Text(route.stops),
                  trailing: Text(route.distance),
                ),
              )),
          const SizedBox(height: 24),
          const Text('Student Allocations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._assignments.map((allocation) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(allocation.studentName),
                  subtitle: Text('${allocation.vehicle} • ${allocation.route}'),
                ),
              )),
        ],
      ),
    );
  }

  void _showVehicleDialog(BuildContext context, {Vehicle? vehicle}) {
    final nameController = TextEditingController(text: vehicle?.name ?? '');
    final registrationController = TextEditingController(text: vehicle?.registration ?? '');
    final capacityController = TextEditingController(text: vehicle?.capacity.toString() ?? '');
    String selectedRoute = vehicle?.assignedRoute ?? (_routes.isNotEmpty ? _routes.first.name : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(vehicle == null ? 'Add Vehicle' : 'Edit Vehicle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Vehicle Name')),
              TextField(controller: registrationController, decoration: const InputDecoration(labelText: 'Registration Number')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedRoute.isNotEmpty ? selectedRoute : null,
                items: _routes.map((route) => DropdownMenuItem(value: route.name, child: Text(route.name))).toList(),
                decoration: const InputDecoration(labelText: 'Assigned Route'),
                onChanged: (value) => selectedRoute = value ?? selectedRoute,
              ),
              TextField(controller: capacityController, decoration: const InputDecoration(labelText: 'Capacity'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final registration = registrationController.text.trim();
              final capacity = int.tryParse(capacityController.text.trim()) ?? 0;
              if (name.isEmpty || registration.isEmpty || capacity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid vehicle details.')));
                return;
              }
              setState(() {
                if (vehicle != null) {
                  vehicle.name = name;
                  vehicle.registration = registration;
                  vehicle.capacity = capacity;
                  vehicle.assignedRoute = selectedRoute;
                } else {
                  _vehicles.add(Vehicle(
                    id: _vehicles.isEmpty ? 1 : _vehicles.last.id + 1,
                    name: name,
                    registration: registration,
                    capacity: capacity,
                    assignedRoute: selectedRoute,
                  ));
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

  void _showDriverDialog(BuildContext context, {Driver? driver}) {
    final nameController = TextEditingController(text: driver?.name ?? '');
    final licenseController = TextEditingController(text: driver?.license ?? '');
    final phoneController = TextEditingController(text: driver?.phone ?? '');
    String assignedVehicle = driver?.assignedVehicle ?? (_vehicles.isNotEmpty ? _vehicles.first.name : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(driver == null ? 'Add Driver' : 'Edit Driver'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Driver Name')),
              TextField(controller: licenseController, decoration: const InputDecoration(labelText: 'License Number')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: assignedVehicle.isNotEmpty ? assignedVehicle : null,
                items: _vehicles.map((vehicle) => DropdownMenuItem(value: vehicle.name, child: Text(vehicle.name))).toList(),
                decoration: const InputDecoration(labelText: 'Assigned Vehicle'),
                onChanged: (value) => assignedVehicle = value ?? assignedVehicle,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final license = licenseController.text.trim();
              final phone = phoneController.text.trim();
              if (name.isEmpty || license.isEmpty || phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid driver details.')));
                return;
              }
              setState(() {
                if (driver != null) {
                  driver.name = name;
                  driver.license = license;
                  driver.phone = phone;
                  driver.assignedVehicle = assignedVehicle;
                } else {
                  _drivers.add(Driver(
                    id: _drivers.isEmpty ? 1 : _drivers.last.id + 1,
                    name: name,
                    license: license,
                    phone: phone,
                    assignedVehicle: assignedVehicle,
                  ));
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

  void _showRouteDialog(BuildContext context, {TransportRoute? route}) {
    final nameController = TextEditingController(text: route?.name ?? '');
    final stopsController = TextEditingController(text: route?.stops ?? '');
    final distanceController = TextEditingController(text: route?.distance ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(route == null ? 'Add Route' : 'Edit Route'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Route Name')),
              TextField(controller: stopsController, decoration: const InputDecoration(labelText: 'Stops')), 
              TextField(controller: distanceController, decoration: const InputDecoration(labelText: 'Distance')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final stops = stopsController.text.trim();
              final distance = distanceController.text.trim();
              if (name.isEmpty || stops.isEmpty || distance.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid route details.')));
                return;
              }
              setState(() {
                if (route != null) {
                  route.name = name;
                  route.stops = stops;
                  route.distance = distance;
                } else {
                  _routes.add(TransportRoute(
                    id: _routes.isEmpty ? 1 : _routes.last.id + 1,
                    name: name,
                    stops: stops,
                    distance: distance,
                  ));
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

  void _showAllocationDialog(BuildContext context) {
    final studentController = TextEditingController();
    String selectedVehicle = _vehicles.isNotEmpty ? _vehicles.first.name : '';
    String selectedRoute = _routes.isNotEmpty ? _routes.first.name : '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Allocate Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: studentController, decoration: const InputDecoration(labelText: 'Student Name')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedVehicle.isNotEmpty ? selectedVehicle : null,
                items: _vehicles.map((vehicle) => DropdownMenuItem(value: vehicle.name, child: Text(vehicle.name))).toList(),
                decoration: const InputDecoration(labelText: 'Vehicle'),
                onChanged: (value) => selectedVehicle = value ?? selectedVehicle,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedRoute.isNotEmpty ? selectedRoute : null,
                items: _routes.map((route) => DropdownMenuItem(value: route.name, child: Text(route.name))).toList(),
                decoration: const InputDecoration(labelText: 'Route'),
                onChanged: (value) => selectedRoute = value ?? selectedRoute,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final studentName = studentController.text.trim();
              if (studentName.isEmpty || selectedVehicle.isEmpty || selectedRoute.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid allocation details.')));
                return;
              }
              setState(() {
                _assignments.add(StudentAssignment(
                  id: _assignments.isEmpty ? 1 : _assignments.last.id + 1,
                  studentName: studentName,
                  vehicle: selectedVehicle,
                  route: selectedRoute,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Allocate'),
          ),
        ],
      ),
    );
  }
}

class Vehicle {
  Vehicle({required this.id, required this.name, required this.registration, required this.capacity, required this.assignedRoute});

  final int id;
  String name;
  String registration;
  int capacity;
  String assignedRoute;
}

class Driver {
  Driver({required this.id, required this.name, required this.license, required this.phone, required this.assignedVehicle});

  final int id;
  String name;
  String license;
  String phone;
  String assignedVehicle;
}

class TransportRoute {
  TransportRoute({required this.id, required this.name, required this.stops, required this.distance});

  final int id;
  String name;
  String stops;
  String distance;
}

class StudentAssignment {
  StudentAssignment({required this.id, required this.studentName, required this.vehicle, required this.route});

  final int id;
  final String studentName;
  final String vehicle;
  final String route;
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
