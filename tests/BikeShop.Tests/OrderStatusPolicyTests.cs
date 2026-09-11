using BikeShop.Application.Services;
using BikeShop.Domain.Enums;

namespace BikeShop.Tests;

public sealed class OrderStatusPolicyTests
{
    [Fact]
    public void PendingOrder_CanBeConfirmed_ButCannotSkipToCompleted()
    {
        Assert.True(OrderStatusPolicy.CanTransition(OrderStatus.Pending, OrderStatus.Confirmed));
        Assert.False(OrderStatusPolicy.CanTransition(OrderStatus.Pending, OrderStatus.Completed));
    }
}
