import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/profile_viewmodel.dart';
import '../widgets/profile_card.dart';
import 'profile_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => viewModel.fetchUsers(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              double width = constraints.maxWidth;
              if (width >= 1200) {
                crossAxisCount = 5;
              } else if (width >= 900) {
                crossAxisCount = 4;
              } else if (width >= 600) {
                crossAxisCount = 3;
              }
              double childAspectRatio = 0.75;
              if (viewModel.users.isEmpty) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Center(child: Text(viewModel.error ?? 'No users'));
                }
              }
              return Column(
                children: [
                  // Professional Header with Dropdown
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                      vertical: width * 0.03,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          color: Colors.grey[700],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Filter by Country',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        // Professional Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: viewModel.selectedCountry ?? 'All',
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey[700],
                              ),
                              elevation: 8,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[900],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              dropdownColor: Colors.white,
                              items: [
                                DropdownMenuItem(
                                  value: 'All',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.public_rounded,
                                        size: 18,
                                        color: Colors.blue[600],
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('All Countries'),
                                    ],
                                  ),
                                ),
                                ...viewModel.users
                                    .map((u) => u.country)
                                    .toSet()
                                    .map(
                                      (country) => DropdownMenuItem(
                                        value: country,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 18,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 8),
                                            Text(country),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                              onChanged: (value) =>
                                  viewModel.setCountryFilter(value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Results count indicator
                  if (viewModel.selectedCountry != null &&
                      viewModel.selectedCountry != 'All')
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: Colors.blue[50],
                      child: Text(
                        '${viewModel.filteredUsers.length} ${viewModel.filteredUsers.length == 1 ? 'user' : 'users'} from ${viewModel.selectedCountry}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  // Filtered Grid
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(width * 0.02),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: width * 0.02,
                        mainAxisSpacing: width * 0.02,
                      ),
                      itemCount: viewModel.filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = viewModel.filteredUsers[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileDetailScreen(user: user),
                              ),
                            );
                          },
                          child: ProfileCard(user: user),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
