using BikeShop.Models;
using Microsoft.AspNetCore.Identity;

namespace BikeShop.Data
{
    public static class IdentitySeeder
    {
        public static async Task SeedAsync(IServiceProvider serviceProvider)
        {
            var roleManager =
                serviceProvider.GetRequiredService<RoleManager<IdentityRole>>();

            var userManager =
                serviceProvider.GetRequiredService<UserManager<ApplicationUser>>();

            string[] roles = { "Customer", "Staff", "Admin" };

            foreach (var role in roles)
            {
                if (!await roleManager.RoleExistsAsync(role))
                {
                    await roleManager.CreateAsync(
                        new IdentityRole(role)
                    );
                }
            }

            await CreateUserAsync(
                userManager,
                email: "admin@gmail.com",
                password: "Admin@123",
                fullName: "BikeShop Admin",
                role: "Admin"
            );

            await CreateUserAsync(
                userManager,
                email: "staff@gmail.com",
                password: "Staff@123",
                fullName: "BikeShop Staff",
                role: "Staff"
            );

            await CreateUserAsync(
                userManager,
                email: "customer@gmail.com",
                password: "Customer@123",
                fullName: "BikeShop Customer",
                role: "Customer"
            );
        }

        private static async Task CreateUserAsync(
            UserManager<ApplicationUser> userManager,
            string email,
            string password,
            string fullName,
            string role)
        {
            var user = await userManager.FindByEmailAsync(email);

            if (user == null)
            {
                user = new ApplicationUser
                {
                    UserName = email,
                    Email = email,
                    FullName = fullName,
                    EmailConfirmed = true,
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow
                };

                var result = await userManager.CreateAsync(
                    user,
                    password
                );

                if (!result.Succeeded)
                {
                    var errors = string.Join(
                        ", ",
                        result.Errors.Select(e => e.Description)
                    );

                    throw new Exception(
                        $"Cannot create user {email}: {errors}"
                    );
                }
            }

            if (!await userManager.IsInRoleAsync(user, role))
            {
                await userManager.AddToRoleAsync(user, role);
            }
        }
    }
}